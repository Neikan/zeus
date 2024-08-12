#!/bin/bash

app_name=$(grep -oP '^name: \K[\w\d.+]+' pubspec.yaml)
build_version=$(grep -oP '^version: \K[\d.+]+' pubspec.yaml)
tag="v$build_version"
echo "Name: $app_name"
echo "Building version: $build_version"
echo "tag: $tag"

dev_apk_name=$app_name-debug-$build_version.apk 
stage_apk_name=$app_name-release-$build_version.apk
stage_aab_name=$app_name-release-$build_version.aab

source_dev_apk_path=build/app/outputs/flutter-apk/app-debug.apk
source_stage_apk_path=build/app/outputs/flutter-apk/app-release.apk
source_stage_aab_path=build/app/outputs/bundle/release/app-release.aab

fvm flutter build apk --release --no-shrink &&
fvm flutter build appbundle --release --no-shrink &&

mv $source_stage_apk_path build/$stage_apk_name
mv $source_stage_aab_path build/$stage_aab_name