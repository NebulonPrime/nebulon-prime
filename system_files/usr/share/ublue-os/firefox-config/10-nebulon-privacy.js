// Nebulon Prime: Firefox privacy defaults. These are defaults, not locks: users can change them in Settings.
// Copied into Firefox's Flatpak system config by Aurora's first-boot setup hook. Listed in docs/PRIVACY.md.

// Telemetry and data reporting
pref("datareporting.healthreport.uploadEnabled", false);
pref("datareporting.policy.dataSubmissionEnabled", false);
pref("datareporting.usage.uploadEnabled", false);
pref("toolkit.telemetry.enabled", false);
pref("toolkit.telemetry.unified", false);
pref("toolkit.telemetry.archive.enabled", false);
pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
pref("browser.newtabpage.activity-stream.telemetry", false);
pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);

// Studies and remote experiments
pref("app.shield.optoutstudies.enabled", false);
pref("app.normandy.enabled", false);

// Ad measurement ("privacy-preserving attribution")
pref("dom.private-attribution.submission.enabled", false);

// Sponsored content
pref("browser.newtabpage.activity-stream.showSponsored", false);
pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
pref("extensions.pocket.enabled", false);
