import pathlib
import runpy
import unittest

select_window = runpy.run_path(str(pathlib.Path(__file__).parents[1] / "scripts/_ventana-cursor.sh"))["select_window"]


class SelectorTests(unittest.TestCase):
    def setUp(self):
        self.monitors = [{"id": 0, "x": 0, "y": 0, "width": 1920, "height": 1080,
                          "scale": 1, "activeWorkspace": {"name": "1"},
                          "specialWorkspace": {"name": ""}}]

    def window(self, address, workspace, focus=0):
        return {"address": address, "monitor": 0, "workspace": {"name": workspace},
                "at": [100, 100], "size": [500, 400], "mapped": True,
                "focusHistoryID": focus}

    def test_hidden_window_cannot_steal_title_bar_click(self):
        windows = [self.window("hidden", "special:minimized", 0), self.window("visible", "1", 5)]
        self.assertEqual(select_window(windows, self.monitors, 200, 80), "visible")

    def test_visible_special_overlay_precedes_normal_workspace(self):
        self.monitors[0]["specialWorkspace"] = {"name": "special:minimized"}
        windows = [self.window("overlay", "special:minimized", 9), self.window("normal", "1", 0)]
        self.assertEqual(select_window(windows, self.monitors, 200, 80), "overlay")

    def test_no_matching_window(self):
        self.assertIsNone(select_window([self.window("window", "1")], self.monitors, 900, 900))

    def test_scaled_monitor_does_not_cover_next_monitor(self):
        self.monitors[0]["scale"] = 2
        self.assertIsNone(select_window([self.window("window", "1")], self.monitors, 1000, 80))


if __name__ == "__main__":
    unittest.main()
