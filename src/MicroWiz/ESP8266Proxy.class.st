Class {
	#name : #ESP8266Proxy,
	#superclass : #MicroPythonProxy,
	#category : #'MicroWiz-MPython'
}

{ #category : #api }
ESP8266Proxy >> icon [
	^ ScratchTheme formAt: #esp8266
]

{ #category : #api }
ESP8266Proxy >> newBlockSpecs [
	^ ESP8266BlockSpecs new
]

{ #category : #api }
ESP8266Proxy >> newCode [
	^ MicroWizCode new
		generator: MicroPythonGenerator new;
		yourself
]
