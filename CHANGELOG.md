# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-01-27

### Added
- Workflow execution API with support for immediate and scheduled workflows
- Target-based execution for subscribers and segments
- New `WorkflowService` and related data models
- Updated example application with workflow execution demo

## 0.0.9

* Downgraded `package_info_plus` dependency to `^8.3.0` to resolve compatibility issues.


## 0.0.8

* Downgraded `firebase_messaging` dependency from `^15.2.8` to `^15.1.0` to resolve compatibility issues with `firebase_core_platform_interface` 5.4.0.

## 0.0.7

* Updated `firebase_messaging` dependency from `^14.7.9` to `^15.2.8` to resolve compatibility issues with `firebase_core` 3.x.

## 0.0.6

### Changed
- Downgraded `firebase_messaging` dependency from `^15.2.9` to `^14.7.9` to resolve `firebase_core_platform_interface` version conflicts

## 0.0.5 - 2025-06-19

### Changed
- Updated `firebase_core` dependency constraint from `^3.15.1` to `'>=3.14.0 <4.0.0'` to resolve version conflicts

## [0.0.4] - 2025-06-19

### Changed
- Updated device_info_plus dependency constraint from ^9.1.1 to '>=9.1.1 <12.0.0' to resolve version conflicts

## [0.0.2] - 2025-06-19
### Changed
- bump firebase_core to 3.8.0


## [0.0.2] - 2025-06-19

### Changed
- Version bump to 0.0.2

## [0.0.1] - 2025-06-10

### Added
- Initial release of PushFire Flutter SDK
- Basic subscriber management functionality
- Device registration with FCM integration
- Tag management capabilities
- Core API client implementation
- Automatic device registration with FCM integration
- Subscriber management (login, update, logout)
- Tag management (add, update, remove single and multiple tags)
- Configurable SDK with custom API endpoints and settings
- Comprehensive error handling with specific exception types
- Event streams for real-time updates
- Built-in logging system for debugging
- Cross-platform support (iOS and Android)
- Complete API coverage for PushFire service

### Features
- **Device Management**
  - Automatic device registration on SDK initialization
  - FCM token management and refresh handling
  - Device information collection (OS, version, manufacturer, etc.)
  - Persistent device storage

- **Subscriber Management**
  - Login/register subscribers with external ID
  - Update subscriber information (name, email, phone)
  - Logout functionality with data cleanup
  - Persistent subscriber storage

- **Tag Management**
  - Add individual tags to subscribers
  - Update existing tag values
  - Remove tags from subscribers
  - Batch operations for multiple tags
  - Error handling for partial failures

- **Configuration**
  - Customizable API base URL
  - API key authentication
  - Configurable request timeouts
  - Debug logging toggle

- **Error Handling**
  - Specific exception types for different error scenarios
  - Network error handling
  - API error handling with status codes
  - Configuration validation

- **Event Streams**
  - Device registration events
  - Subscriber login/logout events
  - FCM token refresh events
  - Real-time status updates

- **Developer Experience**
  - Comprehensive documentation
  - Example application
  - TypeScript-style documentation
  - Best practices guide
  - Troubleshooting guide

### Dependencies
- `flutter`: SDK integration
- `firebase_messaging`: FCM token management
- `http`: API communication
- `device_info_plus`: Device information collection
- `package_info_plus`: App version information
- `shared_preferences`: Local data persistence
- `logging`: Debug logging system

### Platform Support
- iOS 11.0+
- Android API level 21+
- Flutter 3.0.0+
- Dart 3.0.0+

### API Endpoints Covered
- `POST /devices` - Register device
- `PATCH /devices/{id}` - Update device
- `POST /subscribers/login` - Login subscriber
- `PATCH /subscribers/{id}` - Update subscriber
- `POST /subscribers/logout` - Logout subscriber
- `POST /subscribers/tags` - Add subscriber tag
- `PATCH /subscribers/tags` - Update subscriber tag
- `DELETE /subscribers/tags` - Remove subscriber tag

### Security
- API key authentication for all requests
- Secure storage of sensitive data
- No hardcoded credentials
- HTTPS-only communication

### Performance
- Efficient API request batching
- Minimal memory footprint
- Optimized for mobile devices
- Background processing support

[1.0.0]: https://github.com/pushfire/flutter-sdk/releases/tag/v1.0.0
