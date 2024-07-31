# SurfBoard

Surfing the web is for boomers. Surf some boards and find cool shit to do.

# Running the Project

clone the repo and run the following scripts

To download the dependencies:
```bash
# Find all pubspec.yaml files in the project
find . -name "pubspec.yaml" | while read -r file; do
  # Navigate to the directory containing the pubspec.yaml
  dir=$(dirname "$file")
  echo "Running 'dart pub get' in $dir"
  (cd "$dir" && dart pub get)
done
```

To generate the data models:
```bash
# Find all pubspec.yaml files in the project
find . -name "models.dart" | while read -r file; do
  # Navigate to the directory containing the pubspec.yaml
  dir=$(dirname "$file")
  echo "Running 'dart pub get' in $dir"
  (cd "$dir" && flutter pub run build_runner build)
done
```