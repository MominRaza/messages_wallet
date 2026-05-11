## Dependency Management

Don't directly modify the `pubspec.yaml` file. Instead, use the Flutter CLI to manage dependencies:

```bash
flutter pub add <package_name>           # Add a dependency
flutter pub add --dev <package_name>     # Add a dev dependency
flutter pub remove <package_name>        # Remove a dependency
```

## Code Quality Workflow

After making changes to the codebase, ensure all code meets quality standards:

```bash
dart format .          # Format code
flutter analyze        # Check for issues
flutter test           # Run tests
```

## Code Comments Policy

Never add comments in the code. Code should be self-explanatory through clear naming conventions, logical structure, and readable implementation. Write code that speaks for itself.
