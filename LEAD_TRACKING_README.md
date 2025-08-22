# Lead Tracking Feature

This document describes the Lead Tracking feature implementation for the Raferly Flutter app.

## Overview

The Lead Tracking feature provides a comprehensive UI for tracking leads through various sales stages, similar to the design shown in the reference image. It includes:

- Lead information display (name, business referrer)
- Visual timeline of lead stages
- Stage progression management
- Comment system for each stage
- Action buttons for current stages

## Components Created

### 1. Model (`lib/models/model_lead_tracking.dart`)
- `LeadTrackingModel`: Main data structure for lead information
- `LeadStage`: Individual stage data with status, comments, and metadata
- `LeadTrackingSampleData`: Sample data for development and testing

### 2. Controller (`lib/controller/lead_tracking_controller.dart`)
- `LeadTrackingController`: Manages lead tracking state and business logic
- Methods for:
  - Loading lead data
  - Moving between stages
  - Managing comments
  - Stage status management

### 3. Binding (`lib/bindings/lead_tracking_binding.dart`)
- `LeadTrackingBinding`: Dependency injection setup for the controller

### 4. Screen (`lib/screens/lead_tracking_screen.dart`)
- `LeadTrackingScreen`: Main UI implementation
- Features:
  - Header with navigation
  - Lead information section
  - Timeline visualization
  - Interactive stage management
  - Comment dialogs

## Features

### Timeline Stages
- **Initial Contact**: First interaction with the lead
- **Qualification Call**: Assessing lead requirements
- **Proposal Sent**: Sending detailed proposal
- **Follow-up**: Following up on proposal
- **Conversion**: Lead converted to client

### Stage Statuses
- **Completed**: Stage finished with completion date
- **Current**: Active stage with action buttons
- **Upcoming**: Future stages (grayed out)

### Interactive Elements
- **Next Step Button**: Move to next stage
- **Comment Button**: Add comments to current stage
- **Edit Comment**: Modify existing comments
- **Stage Progression**: Visual timeline with status indicators

## Usage

### Testing the Feature
1. Navigate to the home screen
2. Look for the "Test Lead Tracking" button in the header section
3. Tap the button to open the Lead Tracking screen
4. Interact with the timeline stages and buttons

### Integration
To integrate this feature into your app:

1. **Add Route**: Include in your app's routing system
2. **API Integration**: Replace sample data with actual API calls
3. **Navigation**: Add navigation from relevant screens
4. **Customization**: Modify stages and styling as needed

## API Integration

The controller includes placeholder methods for API integration:

```dart
// Replace this method with actual API call
Future<void> loadLeadData(String leadId) async {
  // TODO: Implement actual API call
  // final response = await RESTAuth.getLeadTracking(leadId);
}
```

## Customization

### Adding New Stages
Modify the `LeadTrackingSampleData.getSampleLead()` method to include additional stages.

### Styling
Update colors and styling in the screen file to match your app's design system.

### Business Logic
Extend the controller with additional business logic specific to your needs.

## Dependencies

- Flutter
- GetX (for state management)
- Existing app resources (colors, fonts, etc.)

## File Structure

```
lib/
├── models/
│   └── model_lead_tracking.dart
├── controller/
│   └── lead_tracking_controller.dart
├── bindings/
│   └── lead_tracking_binding.dart
└── screens/
    └── lead_tracking_screen.dart
```

## Future Enhancements

- Real-time updates
- Push notifications for stage changes
- Integration with CRM systems
- Advanced analytics and reporting
- Multi-language support
- Offline capability

## Notes

- Currently uses sample data for development
- Designed to match the existing app's design patterns
- Follows GetX architecture patterns
- Responsive design for different screen sizes
