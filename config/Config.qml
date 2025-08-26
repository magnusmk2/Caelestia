import Quickshell
import Quickshell.Io
import qs.utils
pragma Singleton

Singleton {
    id: root

    property alias appearance: adapter.appearance
    property alias general: adapter.general
    property alias background: adapter.background
    property alias bar: adapter.bar
    property alias border: adapter.border
    property alias dashboard: adapter.dashboard
    property alias controlCenter: adapter.controlCenter
    property alias launcher: adapter.launcher
    property alias notifs: adapter.notifs
    property alias osd: adapter.osd
    property alias session: adapter.session
    property alias winfo: adapter.winfo
    property alias lock: adapter.lock
    property alias services: adapter.services
    property alias paths: adapter.paths

    FileView {
        path: `${Paths.stringify(Paths.config)}/shell.json`
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: adapter

            property AppearanceConfig appearance
            property GeneralConfig general
            property BackgroundConfig background
            property BarConfig bar
            property BorderConfig border
            property DashboardConfig dashboard
            property ControlCenterConfig controlCenter
            property LauncherConfig launcher
            property NotifsConfig notifs
            property OsdConfig osd
            property SessionConfig session
            property WInfoConfig winfo
            property LockConfig lock
            property ServiceConfig services
            property UserPaths paths

            appearance: AppearanceConfig {
            }

            general: GeneralConfig {
            }

            background: BackgroundConfig {
            }

            bar: BarConfig {
            }

            border: BorderConfig {
            }

            dashboard: DashboardConfig {
            }

            controlCenter: ControlCenterConfig {
            }

            launcher: LauncherConfig {
            }

            notifs: NotifsConfig {
            }

            osd: OsdConfig {
            }

            session: SessionConfig {
            }

            winfo: WInfoConfig {
            }

            lock: LockConfig {
            }

            services: ServiceConfig {
            }

            paths: UserPaths {
            }

        }

    }

}
