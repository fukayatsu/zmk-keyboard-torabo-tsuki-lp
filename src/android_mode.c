// SPDX-License-Identifier: MIT
//
// Android モード (config/keymap.keymap の Layer 5) を接続先に合わせて自動で ON/OFF する
//   - BLE プロファイル ANDROID_MODE_BLE_PROFILE (BT1) に切り替えたら ON
//   - それ以外の BLE プロファイルや USB に切り替えたら OFF
//   - 起動時は endpoint_changed が発生しないので、少し待ってから現在の接続先で判定する
// BT レイヤーの &tog 5 で手動で切り替えることもできる (次に接続先が変わるまで有効)

#include <zephyr/sys/util_macro.h>

#if IS_ENABLED(CONFIG_ZMK_SPLIT_ROLE_CENTRAL) && IS_ENABLED(CONFIG_ZMK_BLE)

#include <zephyr/kernel.h>
#include <zephyr/init.h>
#include <zephyr/logging/log.h>

#include <zmk/endpoints.h>
#include <zmk/event_manager.h>
#include <zmk/events/endpoint_changed.h>
#include <zmk/keymap.h>

LOG_MODULE_REGISTER(android_mode, CONFIG_ZMK_LOG_LEVEL);

#define ANDROID_MODE_LAYER 5
#define ANDROID_MODE_BLE_PROFILE 1
#define ANDROID_MODE_BOOT_DELAY_MS 3000

BUILD_ASSERT(ANDROID_MODE_LAYER < ZMK_KEYMAP_LAYERS_LEN, "Android mode layer does not exist");

static void apply_endpoint(struct zmk_endpoint_instance ep) {
    zmk_keymap_layer_id_t layer = zmk_keymap_layer_index_to_id(ANDROID_MODE_LAYER);
    bool android =
        ep.transport == ZMK_TRANSPORT_BLE && ep.ble.profile_index == ANDROID_MODE_BLE_PROFILE;

    LOG_INF("endpoint transport=%d profile=%d -> android mode %s", ep.transport,
            ep.transport == ZMK_TRANSPORT_BLE ? ep.ble.profile_index : -1,
            android ? "on" : "off");

    if (android) {
        zmk_keymap_layer_activate(layer);
    } else {
        zmk_keymap_layer_deactivate(layer);
    }
}

static int android_mode_listener(const zmk_event_t *eh) {
    const struct zmk_endpoint_changed *ev = as_zmk_endpoint_changed(eh);
    if (ev != NULL) {
        apply_endpoint(ev->endpoint);
    }
    return ZMK_EV_EVENT_BUBBLE;
}

ZMK_LISTENER(android_mode, android_mode_listener);
ZMK_SUBSCRIPTION(android_mode, zmk_endpoint_changed);

static void android_mode_boot_work_cb(struct k_work *work) {
    apply_endpoint(zmk_endpoints_selected());
}

static K_WORK_DELAYABLE_DEFINE(android_mode_boot_work, android_mode_boot_work_cb);

static int android_mode_init(void) {
    k_work_schedule(&android_mode_boot_work, K_MSEC(ANDROID_MODE_BOOT_DELAY_MS));
    return 0;
}

SYS_INIT(android_mode_init, APPLICATION, 99);

#endif
