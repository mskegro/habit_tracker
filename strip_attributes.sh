#!/bin/bash
echo "Stripping extended attributes from build folder..."
xattr -cr ~/Desktop/FlutterProjects/habit_tracker/build/macos 2>/dev/null || true
find ~/Desktop/FlutterProjects/habit_tracker/build/macos -name ".DS_Store" -delete 2>/dev/null || true
