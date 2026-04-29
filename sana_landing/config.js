const CONFIG = {
    appName: "Sana | سناء",
    downloadLinks: {
        playStore: "https://play.google.com/store/apps/details?id=com.sana.app",
        appStore: "https://apps.apple.com/app/sana/id123456789",
        webApp: "https://app.sana.app"
    }
};

document.addEventListener('DOMContentLoaded', () => {
    document.getElementById('play-store').href = CONFIG.downloadLinks.playStore;
    document.getElementById('app-store').href = CONFIG.downloadLinks.appStore;
});
