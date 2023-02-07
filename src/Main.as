void Main() {
    startnew(MainCoro);
}

void MainCoro() {
    while (true) {
        while (GetApp().CurrentPlayground is null) yield();
        while (GetApp().CurrentPlayground.UIConfigs[0].UISequence != CGamePlaygroundUIConfig::EUISequence::Playing) yield();
        yield();
        try {
            auto modelNod = GetApp().GlobalCatalog
                .Chapters[1] // #10003
                .Articles[0] // CarSport
                .LoadedNod; // CGameItemModel
            auto model = cast<CGameItemModel>(modelNod);
            // cam1 and cam2 don't have many useful properties exposed. maybe `Dev::`?
            auto cam1 = cast<CPlugVehicleCameraRace2Model>(model.Cameras[0]); // "Behind"
            auto cam2 = cast<CPlugVehicleCameraRace3Model>(model.Cameras[1]); // "Close"
            auto cam3 = cast<CPlugVehicleCameraInternalModel>(model.Cameras[2]); // "Internal"
            UpdateCam3(cam3);
        } catch {}
    }
}

int PeriodLength = 5000;

void UpdateCam3(CPlugVehicleCameraInternalModel@ cam3) {
    auto state = VehicleState::ViewingPlayerState();
    float speedProg = state.FrontSpeed / 1000.0;
    cam3.Fov = Math::Lerp(65.0, 130.0, Math::Sqrt(speedProg));
    cam3.RelativePos = Math::Lerp(vec3(.2, 1.235, -1.2), vec3(-.2, 1.435, -3.2), speedProg);
    // int stage = Time::Now / PeriodLength % 3;
    // float progress = float(Time::Now % PeriodLength) / float(PeriodLength);
    // if (stage == 0) {

    // } else if (stage == 1) {

    // } else if (stage == 2) {

    // }
}




void Notify(const string &in msg) {
    UI::ShowNotification(Meta::ExecutingPlugin().Name, msg);
    trace("Notified: " + msg);
}

void NotifyError(const string &in msg) {
    warn(msg);
    UI::ShowNotification(Meta::ExecutingPlugin().Name + ": Error", msg, vec4(.9, .3, .1, .3), 15000);
}

void NotifyWarning(const string &in msg) {
    warn(msg);
    UI::ShowNotification(Meta::ExecutingPlugin().Name + ": Warning", msg, vec4(.9, .6, .2, .3), 15000);
}

const string PluginIcon = Icons::PlayCircle;
const string MenuTitle = "\\$3f3" + PluginIcon + "\\$z " + Meta::ExecutingPlugin().Name;

// show the window immediately upon installation
[Setting hidden]
bool ShowWindow = true;

/** Render function called every frame intended only for menu items in `UI`. */
void RenderMenu() {
    if (UI::MenuItem(MenuTitle, "", ShowWindow)) {
        ShowWindow = !ShowWindow;
    }
}
