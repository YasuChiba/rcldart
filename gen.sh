
rm -rf ffigen/src
mkdir ffigen/src

vcs import --input ffigen/ros2-flutter.repos ffigen/src/
flutter pub run ffigen --config ffigen/ffigen_rcl.yaml