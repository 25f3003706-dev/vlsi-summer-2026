from libraries import *

from pathlib import Path
import shutil


class ProjectManager:

    def __init__(self, root="."):

        self.root = Path(root).resolve()

        self.destinations = {

            ".vvp": self.root / "sim",

            ".out": self.root / "build",

            ".vcd": self.root / "waves",

            ".fst": self.root / "waves",

            ".log": self.root / "logs",

            ".rpt": self.root / "reports",

            ".json": self.root / "reports",

            ".gds": self.root / "gds",

            ".lef": self.root / "gds",

            ".def": self.root / "gds",

            ".spef": self.root / "gds",

            ".sdf": self.root / "gds",

            ".vg": self.root / "netlist",

            "_netlist.v": self.root / "netlist"

        }

        for folder in set(self.destinations.values()):
            folder.mkdir(parents=True, exist_ok=True)

    def organize(self):

        for file in self.root.rglob("*"):

            if not file.is_file():
                continue

            # Never move RTL/Testbench source files
            if file.suffix in [".v", ".sv"]:

                if "_netlist" not in file.stem:
                    continue

            destination = None

            # Handle netlists
            if file.name.endswith("_netlist.v"):
                destination = self.root / "netlist"

            # Handle remaining extensions
            elif file.suffix in self.destinations:
                destination = self.destinations[file.suffix]

            if destination is None:
                continue

            target = destination / file.name

            if file.resolve() == target.resolve():
                continue

            shutil.move(str(file), str(target))

            print(f"Moved {file.name} -> {destination.name}")