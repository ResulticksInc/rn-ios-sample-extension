/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React, { Component, useEffect } from 'react';
import {
	SafeAreaView,
	StyleSheet,
	ScrollView,
	View,
	Text,
	Button,
	StatusBar,
	NativeEventEmitter,
	NativeModules,
	DeviceEventEmitter,
	Linking,
	Alert
} from 'react-native';
import messaging from '@react-native-firebase/messaging';





let fcmtoken = ""

const payloadConversion = (notfication) => {
	var cache = [];
	var payload = JSON.stringify(notfication, function (key, value) {
		if (typeof value === 'object' && value !== null) {
			if (cache.indexOf(value) !== -1) {
				return;
			}
			cache.push(value);
		}
		return value;
	});
	cache = null;
	return JSON.parse(payload);
}

messaging().onMessage(async remoteMessage => {
	if(Platform.OS === 'ios') {
		NativeModules.ReReactNativeSDK.onNotificationPayloadReceiver(JSON.stringify(remoteMessage), 1);
	}
})

const App: () => React$Node = () => {

	const checkToken = async () => {
		const fcmToken = await messaging().getToken();
		if (fcmToken) {
			fcmtoken = fcmToken
			console.log(fcmToken);
		}
	}

	async function requestUserPermission() {
		const authStatus = await messaging().requestPermission();
		const enabled =
			authStatus === messaging.AuthorizationStatus.AUTHORIZED ||
			authStatus === messaging.AuthorizationStatus.PROVISIONAL;

		if (enabled) {
			console.log('Authorization status:', authStatus);
		}
	}

	useEffect(()  => {
		
		requestUserPermission()
		checkToken()
		if (Platform.OS == 'ios') {
			const { ReReactNativeSDK } = NativeModules
			const resuticksEventEmitter = new NativeEventEmitter(ReReactNativeSDK)
			resuticksEventEmitter.addListener("smartLinkNotificationData",
				(smartLinkData) => {
					//Todo
					console.log("smartLinkData: " + smartLinkData);
				})
		} else {
			DeviceEventEmitter.addListener('resulticksNotification', (data) => {
				//Todo Notification tab data
			})
			Linking.addEventListener('url', ({ url }) => {
				NativeModules.ReReactNativeSDK.getDeepLink((error, data) => {

					data = JSON.parse(data);
					let customParam = JSON.parse(data.customParams);
					alert("URL " + customParam.url);
				});
			})
			Linking.getInitialURL().then((url) => {

				NativeModules.ReReactNativeSDK.getDeepLink((error, data) => {

					data = JSON.parse(data);
					let customParam = JSON.parse(data.customParams);
					alert("URL " + customParam.url);
				});
			})
		}



	}, [])



	/* User Register */
	register = () => {
		var resUser = {
			userUniqueId: 'lrajarammca@gmail.com',
			name: 'user-name',
			age: 'user-age',
			email: 'lrajarammca@gmail.com',
			phone: 'mobile-number',
			gender: 'user-gender',
			token: fcmtoken,
			profileUrl: 'user-profile-url'
		};

		console.log('Register App.js' + JSON.stringify(resUser));

		NativeModules.ReReactNativeSDK.userRegister(JSON.stringify(resUser));

	};

	/* Custom Event */
	customEvent = () => {
		// Sending custom event
		// Custom event : event name and data both fully customizable for the user wish

		var customEventObject = {
			eventName: 'Your custom event name',
			data: {
				productId: 'Your product id',
				productName: 'Your product name'
			}
		};
		NativeModules.ReReactNativeSDK.customEvent(JSON.stringify(customEventObject));
	};

	// Screen tracking: Developer must pass screen name according to the presented screen
	userNavigation = () => {
		//	NativeModules.ReReactNativeSDK.screenNavigation('HomeScreen');
	};

	// Location update: Developer must pass(Live or required location) the location object with latitude and longitude key as a String format
	userlocationUpdate = () => {
		var lat = 13.123456789012345.toString();
		var long = 80.123456789012345.toString();
		var location = {
			latitude: 13.123456789012345,
			longitude: 80.123456789012345
		};
		var location1 = {
			latitude: lat,
			longitude: long
		};
		console.log("Location  = " + JSON.stringify(location));
		console.log("Lat = " + lat + "LONG" + long);
		console.log("Location 1 " + JSON.stringify(location1));
		NativeModules.ReReactNativeSDK.locationUpdate(JSON.stringify(location1));
	};

	// Refer Notification Related things in Notification.js file.
	getNotification = () => {
		this.props.navigation.navigate('Notification');
	}

	// Custom Conversation 
	appConversation = () => {
		NativeModules.ReReactNativeSDK.appConversionTracking();
	};
	appConversation1 = () => {
		let s = { name: "Product add", price: 100 }
		NativeModules.ReReactNativeSDK.appConversionTrackingWithData(JSON.stringify(s))
	};
	readNotification = () => {
		NativeModules.ReReactNativeSDK.getUnReadNotificationCount((count) => {
			if (count != undefined) {
				console.log("unread count: ", count)
			}
		})
	}

	return (
		<>
			<StatusBar barStyle="dark-content" />
			<SafeAreaView>
				<View style={styles.container}>
					<Text style={styles.welcome}> Welcome to Resulticks App!! </Text>
					<View style={{ marginTop: 10, width: "100%", height: 40, margin: 10 }}>
						<Button style={styles.button} onPress={() => { register() }} title="register" color="#FF6347" />
					</View>

					<View style={{ marginTop: 10, width: "100%", height: 40, margin: 10 }}>
						<Button style={styles.button} onPress={customEvent} title="customEvent" color="#FF6347" />
					</View>

					<View style={{ marginTop: 10, width: "100%", height: 40, margin: 10 }}>
						<Button style={styles.button} onPress={userNavigation} title="screen Tracking" color="#FF6347" />
					</View>

					<View style={{ marginTop: 10, width: "100%", height: 40, margin: 10 }}>
						<Button style={styles.button} onPress={userlocationUpdate} title="Locaction Update" color="#FF6347" />
					</View>

					<View style={{ marginTop: 10, width: "100%", height: 40, margin: 10 }}>
						<Button style={styles.button} onPress={getNotification} title="Notification" color="#FF6347" />
					</View>

					<View style={{ marginTop: 10, width: "100%", height: 40, margin: 10 }}>
						<Button style={styles.button} onPress={appConversation} title="App Conversation without data" color="#FF6347" />
					</View>
					<View style={{ marginTop: 10, width: "100%", height: 40, margin: 10 }}>
						<Button style={styles.button} onPress={appConversation1} title="App Conversation with data" color="#FF6347" />
					</View>
					<View style={{ marginTop: 10, width: "100%", height: 40, margin: 10 }}>
						<Button style={styles.button} onPress={readNotification} title="read" color="#FF6347" />
					</View>
				</View>
			</SafeAreaView>
		</>
	);
};

const styles = StyleSheet.create({
	container: {
		flex: 1,
		marginTop: 50
	},
	title: {
		textAlign: 'center',
		marginVertical: 8,
	},
	button: {
		marginBottom: 20,
		padding: 30
	},
	space: {
		width: 20, // or whatever size you need
		height: 20,
	},
	fixToText: {
		flexDirection: 'row',
		justifyContent: 'space-between',
	},
	separator: {
		marginVertical: 8,
		borderBottomColor: '#737373',
		borderBottomWidth: StyleSheet.hairlineWidth,
	},
});

export default App;
