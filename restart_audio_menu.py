import rumps
import subprocess
import webbrowser

SCRIPT_PATH = '/Users/tonytopp/restart_audio_services.sh'

class AudioMenuApp(rumps.App):
    def __init__(self):
        super(AudioMenuApp, self).__init__(
            "Diktering",
            icon=None,
            menu=["Starta om ljud & diktering", None, "Stötta på BuyMeACoffee"]
        )

    @rumps.clicked("Starta om ljud & diktering")
    def restart_audio_services(self, _):
        try:
            result = subprocess.run(["bash", SCRIPT_PATH], capture_output=True, text=True)
            if result.returncode == 0:
                rumps.notification("Diktering", "Tjänster omstartade", "Ljud- och dikteringstjänster har startats om.")
            else:
                rumps.notification("Diktering", "Fel", f"Fel vid omstart:\n{result.stderr}")
        except Exception as e:
            rumps.notification("Diktering", "Fel", f"Kunde inte köra skriptet:\n{e}")

    @rumps.clicked("Stötta på BuyMeACoffee")
    def open_bmc(self, _):
        webbrowser.open("https://buymeacoffee.com/topptony02c")

if __name__ == "__main__":
    AudioMenuApp().run()
