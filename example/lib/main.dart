import 'package:flutter/material.dart';
import 'package:pushfire_sdk/pushfire_sdk.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase first
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize PushFire SDK
  try {
    await PushFireSDK.initialize(
      PushFireConfig(
        apiKey: 'b68f396b-96c4-4598-839b-d11c9903a038', // Replace with your actual API key
        enableLogging: true, // Enable for debugging
        timeoutSeconds: 30,
      ),
    );
    print('PushFire SDK initialized successfully');
  } catch (e) {
    print('Failed to initialize PushFire SDK: $e');
  }
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PushFire SDK Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PushFireExample(),
    );
  }
}

class PushFireExample extends StatefulWidget {
  @override
  _PushFireExampleState createState() => _PushFireExampleState();
}

class _PushFireExampleState extends State<PushFireExample> {
  final TextEditingController _externalIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _tagIdController = TextEditingController();
  final TextEditingController _tagValueController = TextEditingController();
  
  Subscriber? _currentSubscriber;
  Device? _currentDevice;
  String _status = 'Ready';
  
  late StreamSubscription _deviceSubscription;
  late StreamSubscription _subscriberLoginSubscription;
  late StreamSubscription _subscriberLogoutSubscription;
  late StreamSubscription _fcmSubscription;
  
  @override
  void initState() {
    super.initState();
    _setupEventListeners();
    _loadCurrentData();
  }
  
  void _setupEventListeners() {
    // Listen to device registration events
    _deviceSubscription = PushFireSDK.instance.onDeviceRegistered.listen(
      (device) {
        setState(() {
          _currentDevice = device;
          _status = 'Device registered: ${device.id}';
        });
        print('Device registered: ${device.id}');
      },
    );
    
    // Listen to subscriber login events
    _subscriberLoginSubscription = PushFireSDK.instance.onSubscriberLoggedIn.listen(
      (subscriber) {
        setState(() {
          _currentSubscriber = subscriber;
          _status = 'Subscriber logged in: ${subscriber.name}';
        });
        print('Subscriber logged in: ${subscriber.name}');
      },
    );
    
    // Listen to subscriber logout events
    _subscriberLogoutSubscription = PushFireSDK.instance.onSubscriberLoggedOut.listen(
      (_) {
        setState(() {
          _currentSubscriber = null;
          _status = 'Subscriber logged out';
        });
        print('Subscriber logged out');
      },
    );

    // Listen to FCM token refresh events
    _fcmSubscription = PushFireSDK.instance.onFcmTokenRefresh.listen(
      (token) {
        setState(() {
          _status = 'FCM token refreshed';
        });
        print('FCM token refreshed: $token');
      },
    );
  }
  
  Future<void> _loadCurrentData() async {
    try {
      final subscriber = await PushFireSDK.instance.getCurrentSubscriber();
      final device = PushFireSDK.instance.currentDevice;
      
      setState(() {
        _currentSubscriber = subscriber;
        _currentDevice = device;
        _status = 'Data loaded';
      });
    } catch (e) {
      setState(() {
        _status = 'Error loading data: $e';
      });
    }
  }
  
  Future<void> _loginSubscriber() async {
    if (_externalIdController.text.isEmpty) {
      setState(() {
        _status = 'Please enter an external ID';
      });
      return;
    }
    
    try {
      setState(() {
        _status = 'Logging in subscriber...';
      });
      
      final subscriber = await PushFireSDK.instance.loginSubscriber(
        externalId: _externalIdController.text,
        name: _nameController.text.isNotEmpty ? _nameController.text : null,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      );
      
      setState(() {
        _currentSubscriber = subscriber;
        _status = 'Subscriber logged in successfully';
      });
    } catch (e) {
      setState(() {
        _status = 'Login failed: $e';
      });
    }
  }
  
  Future<void> _updateSubscriber() async {
    if (_currentSubscriber == null) {
      setState(() {
        _status = 'No subscriber logged in';
      });
      return;
    }
    
    try {
      setState(() {
        _status = 'Updating subscriber...';
      });
      
      final subscriber = await PushFireSDK.instance.updateSubscriber(
        name: _nameController.text.isNotEmpty ? _nameController.text : null,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      );
      
      setState(() {
        _currentSubscriber = subscriber;
        _status = 'Subscriber updated successfully';
      });
    } catch (e) {
      setState(() {
        _status = 'Update failed: $e';
      });
    }
  }
  
  Future<void> _logoutSubscriber() async {
    try {
      setState(() {
        _status = 'Logging out subscriber...';
      });
      
      await PushFireSDK.instance.logoutSubscriber();
      
      setState(() {
        _currentSubscriber = null;
        _status = 'Subscriber logged out successfully';
      });
    } catch (e) {
      setState(() {
        _status = 'Logout failed: $e';
      });
    }
  }
  
  Future<void> _addTag() async {
    if (_tagIdController.text.isEmpty || _tagValueController.text.isEmpty) {
      setState(() {
        _status = 'Please enter tag ID and value';
      });
      return;
    }
    
    if (_currentSubscriber == null) {
      setState(() {
        _status = 'No subscriber logged in';
      });
      return;
    }
    
    try {
      setState(() {
        _status = 'Adding tag...';
      });
      
      final tag = await PushFireSDK.instance.addTag(
        _tagIdController.text,
        _tagValueController.text,
      );
      
      setState(() {
        _status = 'Tag added: ${tag.tagId} = ${tag.value}';
      });
      
      _tagIdController.clear();
      _tagValueController.clear();
    } catch (e) {
      setState(() {
        _status = 'Add tag failed: $e';
      });
    }
  }
  
  Future<void> _removeTag() async {
    if (_tagIdController.text.isEmpty) {
      setState(() {
        _status = 'Please enter tag ID to remove';
      });
      return;
    }
    
    if (_currentSubscriber == null) {
      setState(() {
        _status = 'No subscriber logged in';
      });
      return;
    }
    
    try {
      setState(() {
        _status = 'Removing tag...';
      });
      
      await PushFireSDK.instance.removeTag(_tagIdController.text);
      
      setState(() {
        _status = 'Tag removed: ${_tagIdController.text}';
      });
      
      _tagIdController.clear();
    } catch (e) {
      setState(() {
        _status = 'Remove tag failed: $e';
      });
    }
  }
  
  Future<void> _addMultipleTags() async {
    if (_currentSubscriber == null) {
      setState(() {
        _status = 'No subscriber logged in';
      });
      return;
    }
    
    try {
      setState(() {
        _status = 'Adding multiple tags...';
      });
      
      final tags = await PushFireSDK.instance.addTags({
        'user_type': 'premium',
        'subscription_plan': 'yearly',
        'region': 'us-west',
        'app_version': '1.0.0',
      });
      
      setState(() {
        _status = 'Added ${tags.length} tags successfully';
      });
    } catch (e) {
      setState(() {
        _status = 'Add multiple tags failed: $e';
      });
    }
  }
  
  Future<void> _resetSDK() async {
    try {
      setState(() {
        _status = 'Resetting SDK...';
      });
      
      await PushFireSDK.instance.reset();
      
      setState(() {
        _currentSubscriber = null;
        _currentDevice = null;
        _status = 'SDK reset successfully';
      });
      
      // Clear form fields
      _externalIdController.clear();
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _tagIdController.clear();
      _tagValueController.clear();
    } catch (e) {
      setState(() {
        _status = 'Reset failed: $e';
      });
    }
  }
  
  @override
  void dispose() {
    _deviceSubscription.cancel();
    _subscriberLoginSubscription.cancel();
    _subscriberLogoutSubscription.cancel();
    _fcmSubscription.cancel();
    
    _externalIdController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _tagIdController.dispose();
    _tagValueController.dispose();
    
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PushFire SDK Example'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8),
                    Text(_status),
                    SizedBox(height: 8),
                    Text('SDK Initialized: ${PushFireSDK.isInitialized}'),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Current Data Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Data',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8),
                    Text('Device ID: ${_currentDevice?.id ?? 'Not registered'}'),
                    Text('Subscriber ID: ${_currentSubscriber?.id ?? 'Not logged in'}'),
                    Text('Subscriber Name: ${_currentSubscriber?.name ?? 'N/A'}'),
                    Text('Subscriber Email: ${_currentSubscriber?.email ?? 'N/A'}'),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Subscriber Form Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subscriber Management',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _externalIdController,
                      decoration: InputDecoration(
                        labelText: 'External ID *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _loginSubscriber,
                            child: Text('Login'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _currentSubscriber != null ? _updateSubscriber : null,
                            child: Text('Update'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _currentSubscriber != null ? _logoutSubscriber : null,
                            child: Text('Logout'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Tag Management Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tag Management',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _tagIdController,
                      decoration: InputDecoration(
                        labelText: 'Tag ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _tagValueController,
                      decoration: InputDecoration(
                        labelText: 'Tag Value',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _currentSubscriber != null ? _addTag : null,
                            child: Text('Add Tag'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _currentSubscriber != null ? _removeTag : null,
                            child: Text('Remove Tag'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _currentSubscriber != null ? _addMultipleTags : null,
                        child: Text('Add Sample Tags'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Advanced Actions Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Advanced Actions',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _loadCurrentData,
                            child: Text('Refresh Data'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _resetSDK,
                            child: Text('Reset SDK'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}