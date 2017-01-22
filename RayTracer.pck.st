'From Cuis 5.0 of 7 November 2016 [latest update: #2974] on 22 January 2017 at 10:13:17 am'!
'Description Please enter a description for this package'!
!provides: 'RayTracer' 1 2!
!requires: 'Math 3D' 1 21 nil!
!classDefinition: #Camera category: #RayTracer!
Object subclass: #Camera
	instanceVariableNames: 'location direction up right image imagePoker'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RayTracer'!
!classDefinition: 'Camera class' category: #RayTracer!
Camera class
	instanceVariableNames: ''!

!classDefinition: #CompoundFinish category: #RayTracer!
Object subclass: #CompoundFinish
	instanceVariableNames: 'finishes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RayTracer'!
!classDefinition: 'CompoundFinish class' category: #RayTracer!
CompoundFinish class
	instanceVariableNames: ''!

!classDefinition: #FlatColorPigment category: #RayTracer!
Object subclass: #FlatColorPigment
	instanceVariableNames: 'color'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RayTracer'!
!classDefinition: 'FlatColorPigment class' category: #RayTracer!
FlatColorPigment class
	instanceVariableNames: ''!

!classDefinition: #Intersection category: #RayTracer!
Object subclass: #Intersection
	instanceVariableNames: 'object ray distance intersectionPoint normal scene'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RayTracer'!
!classDefinition: 'Intersection class' category: #RayTracer!
Intersection class
	instanceVariableNames: ''!

!classDefinition: #LightSource category: #RayTracer!
Object subclass: #LightSource
	instanceVariableNames: 'location color'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RayTracer'!
!classDefinition: 'LightSource class' category: #RayTracer!
LightSource class
	instanceVariableNames: ''!

!classDefinition: #PhongLightingModelFinish category: #RayTracer!
Object subclass: #PhongLightingModelFinish
	instanceVariableNames: 'ambient diffuse specular specularPower'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RayTracer'!
!classDefinition: 'PhongLightingModelFinish class' category: #RayTracer!
PhongLightingModelFinish class
	instanceVariableNames: ''!

!classDefinition: #Ray category: #RayTracer!
Object subclass: #Ray
	instanceVariableNames: 'origin direction directionLengthSquared'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RayTracer'!
!classDefinition: 'Ray class' category: #RayTracer!
Ray class
	instanceVariableNames: ''!

!classDefinition: #RayTraceObject category: #RayTracer!
Object subclass: #RayTraceObject
	instanceVariableNames: 'texture'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RayTracer'!
!classDefinition: 'RayTraceObject class' category: #RayTracer!
RayTraceObject class
	instanceVariableNames: ''!

!classDefinition: #ReflectionFinish category: #RayTracer!
Object subclass: #ReflectionFinish
	instanceVariableNames: 'reflection'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RayTracer'!
!classDefinition: 'ReflectionFinish class' category: #RayTracer!
ReflectionFinish class
	instanceVariableNames: ''!

!classDefinition: #Scene category: #RayTracer!
Object subclass: #Scene
	instanceVariableNames: 'objects lightSources camera'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RayTracer'!
!classDefinition: 'Scene class' category: #RayTracer!
Scene class
	instanceVariableNames: ''!

!classDefinition: #Texture category: #RayTracer!
Object subclass: #Texture
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RayTracer'!
!classDefinition: 'Texture class' category: #RayTracer!
Texture class
	instanceVariableNames: ''!

!classDefinition: #TextureWithFinish category: #RayTracer!
Texture subclass: #TextureWithFinish
	instanceVariableNames: 'pigment finish'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RayTracer'!
!classDefinition: 'TextureWithFinish class' category: #RayTracer!
TextureWithFinish class
	instanceVariableNames: ''!


!Number methodsFor: '*RayTracer' stamp: 'len 1/17/2017 18:00:54'!
x
	^ Float32Vector3 x: self y: 0 z: 0! !

!Number methodsFor: '*RayTracer' stamp: 'len 1/17/2017 18:01:00'!
y
	^ Float32Vector3 x: 0 y: self z: 0! !

!Number methodsFor: '*RayTracer' stamp: 'len 1/17/2017 18:01:04'!
z
	^ Float32Vector3 x: 0 y: 0 z: self! !

!Float32Vector3 methodsFor: '*RayTracer' stamp: 'len 1/18/2017 21:38:12'!
halfwayVectorTo: aVector 
	^(self + aVector) /= 2.0! !

!Float32Vector3 methodsFor: '*RayTracer' stamp: 'len 1/18/2017 21:37:28'!
reflectRay: aVector 
	^self * ((self dot: aVector) * -2.0) -= aVector! !

!Float32Vector3 methodsFor: '*RayTracer' stamp: 'len 1/18/2017 21:32:27'!
unitVector
	^self copy normalize! !

!Float32Vector3 methodsFor: '*RayTracer' stamp: 'len 1/18/2017 21:30:13'!
unitVectorTowards: aVector 
	^(aVector - self) normalize! !

!Point methodsFor: '*RayTracer' stamp: 'len 1/17/2017 18:01:56'!
@ aNumber
	^Float32Vector3 x: x y: y z: aNumber! !

!Camera methodsFor: 'rendering' stamp: 'len 1/18/2017 21:22:53'!
allPixelsDo: aBlock
	0 to: self image extent y - 1
		do: 
			[:y | 
			0 to: self image extent x - 1
				do: 
					[:x | 
					aBlock value: x value: y]].
	^self image! !

!Camera methodsFor: 'rendering' stamp: 'len 1/18/2017 21:26:18'!
createRayForPixel: aPoint
	| rayDirection scaledX scaledY |
	scaledX _ aPoint x asFloat / image width - 0.5.
	scaledY _ (image height - aPoint y) / image height - 0.5.
	rayDirection _ self direction + (self up * scaledY) += (self right * scaledX).
	^Ray new
		origin: self location;
		direction: rayDirection.! !

!Camera methodsFor: 'accessing'!
direction
	^direction! !

!Camera methodsFor: 'accessing'!
direction: aVector
	direction _ aVector! !

!Camera methodsFor: 'accessing'!
image
	^image! !

!Camera methodsFor: 'accessing'!
image: anObject
	image _ anObject! !

!Camera methodsFor: 'dialect-specific' stamp: 'len 1/18/2017 21:23:12'!
imageAt: aPoint putColor: color
	imagePoker
		pixelAt: aPoint
		put: (color pixelValueForDepth: image depth)! !

!Camera methodsFor: 'dialect-specific' stamp: 'avi 10/12/2003 00:44'!
imageOfSize: aPoint 
	^Form 
		extent: aPoint
		depth: 32! !

!Camera methodsFor: 'dialect-specific' stamp: 'len 1/20/2017 21:56:25'!
imageSize: aPoint
	(image notNil and: [image extent = aPoint]) ifTrue: [^ self].
	image _ self imageOfSize: aPoint.
	imagePoker _ BitBlt bitPokerToForm: image.! !

!Camera methodsFor: 'initializing'!
initialize
	location _ -10 z.
	direction _ 1 z.
	up _ 1 y.
	right _ 1 x.! !

!Camera methodsFor: 'accessing'!
location
	^location! !

!Camera methodsFor: 'accessing'!
location: aVector
	location _ aVector! !

!Camera methodsFor: 'initializing' stamp: 'len 1/18/2017 21:23:42'!
renderScene: aScene 
	self allPixelsDo: 
			[:x :y |
			| point ray color |
			point _ x @ y.
			ray _ self createRayForPixel: point.
			color _ aScene trace: ray.
			self imageAt: point putColor: color].
	^self image! !

!Camera methodsFor: 'accessing'!
right
	^right! !

!Camera methodsFor: 'accessing'!
right: aVector
	right _ aVector! !

!Camera methodsFor: 'accessing'!
up
	^up! !

!Camera methodsFor: 'accessing'!
up: aVector
	up _ aVector! !

!CompoundFinish methodsFor: 'adding'!
addFinish: aFinish
	finishes add: aFinish! !

!CompoundFinish methodsFor: 'rendering' stamp: 'len 1/18/2017 21:43:53'!
colorAt: anIntersection
	| color |
	color _ Float32Color3 new.
	finishes do: [:each| color += (each colorAt: anIntersection)].
	^color! !

!CompoundFinish methodsFor: 'initializing'!
initialize
	finishes _ OrderedCollection new! !

!FlatColorPigment methodsFor: 'accessing'!
color
	^color! !

!FlatColorPigment methodsFor: 'accessing' stamp: 'len 1/17/2017 18:35:49'!
color: aColor
	color _ aColor as: Float32Color3! !

!FlatColorPigment methodsFor: 'rendering'!
colorAt: anIntersection
	^color! !

!Intersection methodsFor: 'rendering'!
colorInScene: aScene 
	scene _ aScene.
	^self object colorAt: self! !

!Intersection methodsFor: 'rendering' stamp: 'len 1/18/2017 21:27:19'!
colorOfReflectedRay
	^self scene trace: (Ray new
				origin: self intersectionPoint;
				direction: self reflectedDirection)! !

!Intersection methodsFor: 'accessing'!
distance
	^distance! !

!Intersection methodsFor: 'accessing'!
distance: aNumber
	distance _ aNumber! !

!Intersection methodsFor: 'rendering'!
eyeRayDirection
	^self ray direction! !

!Intersection methodsFor: 'accessing' stamp: 'len 1/21/2017 19:56:07'!
intersectionPoint
	^intersectionPoint ifNil: [intersectionPoint _ ray pointAtDistance: distance]! !

!Intersection methodsFor: 'rendering' stamp: 'len 1/21/2017 19:44:17'!
normal
	normal ifNotNil: [^ normal].
	normal _ self object normalAt: self intersectionPoint.
	(normal dot: self eyeRayDirection) positive ifTrue: [normal _ normal negated].
	^ normal! !

!Intersection methodsFor: 'rendering' stamp: 'len 1/21/2017 19:39:46'!
normalComponentForLightSource: lightSource 
	| lightSourceVector |
	lightSourceVector _ self intersectionPoint unitVectorTowards: lightSource location.
	^ self normal dot: lightSourceVector! !

!Intersection methodsFor: 'accessing'!
object
	^object! !

!Intersection methodsFor: 'accessing'!
object: aRayTraceObject
	object _ aRayTraceObject! !

!Intersection methodsFor: 'accessing'!
pigmentColor
	^self object texture pigment colorAt: self! !

!Intersection methodsFor: 'accessing'!
ray
	^ray! !

!Intersection methodsFor: 'accessing'!
ray: aRay
	ray _ aRay! !

!Intersection methodsFor: 'rendering'!
reflectedDirection
	^self normal reflectRay: self eyeRayDirection! !

!Intersection methodsFor: 'accessing'!
scene
	^scene! !

!Intersection methodsFor: 'accessing'!
scene: anObject
	scene _ anObject! !

!Intersection class methodsFor: 'instance creation'!
for: anObject ray: aRay distance: aNumber
	^self new
		object: anObject;
		ray: aRay;
		distance: aNumber;
		yourself! !

!LightSource methodsFor: 'accessing'!
color
	^color! !

!LightSource methodsFor: 'accessing' stamp: 'len 1/17/2017 18:36:00'!
color: aColor
	color _ aColor as: Float32Color3! !

!LightSource methodsFor: 'initializing' stamp: 'len 1/17/2017 18:27:07'!
initialize
	self
		color: Float32Color3 white;
		location: 0@10@-10! !

!LightSource methodsFor: 'rendering' stamp: 'len 1/18/2017 21:34:21'!
isIntersectionVisible: anIntersection 
	| lightSourceVector lightSourceDistance ray |
	lightSourceVector _ self location - anIntersection intersectionPoint.
	lightSourceDistance _ lightSourceVector length.
	ray _ (Ray new)
				origin: anIntersection intersectionPoint;
				direction: lightSourceVector /= lightSourceDistance.
	anIntersection scene intersectionsWith: ray
		do: [:intersection | intersection distance < lightSourceDistance ifTrue: [^false]].
	^true! !

!LightSource methodsFor: 'accessing'!
location
	^location! !

!LightSource methodsFor: 'accessing'!
location: aVector
	location _ aVector! !

!PhongLightingModelFinish methodsFor: 'accessing'!
ambient
	^ambient! !

!PhongLightingModelFinish methodsFor: 'accessing' stamp: 'len 1/17/2017 17:41:31'!
ambient: anObject
	ambient _ anObject asFloat! !

!PhongLightingModelFinish methodsFor: 'rendering'!
ambientColorAt: anIntersection 
	^anIntersection pigmentColor * self ambient! !

!PhongLightingModelFinish methodsFor: 'initializing' stamp: 'len 1/19/2017 20:38:12'!
colorAt: anIntersection
	| color dot |
	color _ self ambientColorAt: anIntersection.
	anIntersection scene lightSources do: 
			[:lightSource |
			(lightSource isIntersectionVisible: anIntersection) 
				ifTrue: 
					[dot _ anIntersection normalComponentForLightSource: lightSource.
					dot > 0.0
						ifTrue: 
							[color _ color 
										+ (self diffuseColorAt: anIntersection fromLightSource: lightSource) 
										+= (self specularColorAt: anIntersection lightSource: lightSource)]]].
	^color! !

!PhongLightingModelFinish methodsFor: 'accessing'!
diffuse
	^diffuse! !

!PhongLightingModelFinish methodsFor: 'accessing' stamp: 'len 1/17/2017 17:41:58'!
diffuse: anObject
	diffuse _ anObject asFloat! !

!PhongLightingModelFinish methodsFor: 'rendering' stamp: 'len 1/18/2017 21:16:15'!
diffuseColorAt: anIntersection fromLightSource: lightSource
	| dot |
	dot _ anIntersection normalComponentForLightSource: lightSource.
	^anIntersection pigmentColor * lightSource color *= (dot * self diffuse)! !

!PhongLightingModelFinish methodsFor: 'initializing' stamp: 'len 1/17/2017 17:39:59'!
initialize
	self
		ambient: 0.2;
		diffuse: 0.8;
		specular: 0.0;
		specularPower: 20.0! !

!PhongLightingModelFinish methodsFor: 'accessing'!
specular
	^specular! !

!PhongLightingModelFinish methodsFor: 'accessing' stamp: 'len 1/17/2017 17:42:02'!
specular: anObject
	specular _ anObject asFloat! !

!PhongLightingModelFinish methodsFor: 'rendering' stamp: 'len 1/17/2017 18:27:57'!
specularColorAt: anIntersection lightSource: lightSource
	| halfLength cosAngleOfIncidence halfVector intensity lightSourceVector |
	lightSourceVector _ anIntersection intersectionPoint 
								unitVectorTowards: lightSource location.
	halfVector _ anIntersection eyeRayDirection negated 
				halfwayVectorTo: lightSourceVector.
	halfLength _ halfVector length.
	halfLength > 0.0 
		ifTrue: 
			[cosAngleOfIncidence _ (halfVector dot: anIntersection normal) / halfLength.
			cosAngleOfIncidence > 0.0 
				ifTrue: 
					[intensity _ (cosAngleOfIncidence raisedTo: self specularPower) 
								* self specular.
					^lightSource color * intensity]].
	^Float32Color3 black! !

!PhongLightingModelFinish methodsFor: 'accessing'!
specularPower
	^specularPower! !

!PhongLightingModelFinish methodsFor: 'accessing' stamp: 'len 1/17/2017 17:42:06'!
specularPower: anObject
	specularPower _ anObject asFloat! !

!Ray methodsFor: 'accessing'!
direction
	^direction! !

!Ray methodsFor: 'accessing'!
direction: anObject
	direction _ anObject! !

!Ray methodsFor: 'tracing' stamp: 'len 1/18/2017 21:18:06'!
directionLengthSquared
	^directionLengthSquared ifNil: [directionLengthSquared _ direction dot: direction]! !

!Ray methodsFor: 'accessing'!
origin
	^origin! !

!Ray methodsFor: 'accessing'!
origin: anObject
	origin _ anObject! !

!Ray methodsFor: 'accessing' stamp: 'len 1/22/2017 09:37:30'!
pointAtDistance: d 
	^self direction * d + self origin! !

!RayTraceObject methodsFor: 'tracing'!
colorAt: anIntersection
	^self texture colorAt: anIntersection! !

!RayTraceObject methodsFor: 'initializing'!
initialize
	self
		texture: Texture new! !

!RayTraceObject methodsFor: 'tracing'!
normalAt: aPoint
	self subclassResponsibility! !

!RayTraceObject methodsFor: 'accessing'!
texture
	^texture! !

!RayTraceObject methodsFor: 'accessing'!
texture: aRayTraceTexture
	texture _ aRayTraceTexture! !

!RayTraceObject methodsFor: 'tracing'!
writeIntersectionsWith: aRay into: aCollection
	^self! !

!ReflectionFinish methodsFor: 'rendering'!
colorAt: anIntersection 
	^anIntersection colorOfReflectedRay * reflection! !

!ReflectionFinish methodsFor: 'accessing'!
reflection
	^reflection! !

!ReflectionFinish methodsFor: 'accessing' stamp: 'len 1/17/2017 17:42:13'!
reflection: aNumber
	reflection _ aNumber asFloat! !

!Scene methodsFor: 'scene creation'!
addLightSource: aLightSource
	lightSources add: aLightSource! !

!Scene methodsFor: 'scene creation'!
addObject: anObject
	objects add: anObject! !

!Scene methodsFor: 'tracing'!
allIntersectionsWith: aRay 
	| intersections |
	intersections _ OrderedCollection new.
	self objects 
		do: [:each | each writeIntersectionsWith: aRay into: intersections].
	^intersections asSortedCollection: [:x :y | x distance < y distance].! !

!Scene methodsFor: 'tracing'!
closestIntersectionWith: aRay 
	| intersections |
	intersections _ self allIntersectionsWith: aRay.
	^intersections isEmpty ifTrue: [nil] ifFalse: [intersections first]! !

!Scene methodsFor: 'initializing'!
initialize
	self
		objects: OrderedCollection new;
		lightSources: OrderedCollection new! !

!Scene methodsFor: 'tracing'!
intersectionsWith: aRay do: aBlock
	| intersections |
	intersections _ OrderedCollection new.
	self objects 
		do: [:each | each writeIntersectionsWith: aRay into: intersections.
			intersections do: aBlock.
			intersections _ OrderedCollection new].! !

!Scene methodsFor: 'accessing'!
lightSources
	^lightSources! !

!Scene methodsFor: 'accessing'!
lightSources: aCollection
	lightSources _ aCollection! !

!Scene methodsFor: 'accessing'!
objects
	^objects! !

!Scene methodsFor: 'accessing'!
objects: aCollection
	objects _ aCollection! !

!Scene methodsFor: 'tracing' stamp: 'len 1/17/2017 18:28:07'!
trace: aRay
	| intersection |
	intersection _ self closestIntersectionWith: aRay.
	intersection isNil ifTrue: [^Float32Color3 black].
	^intersection colorInScene: self! !

!Texture methodsFor: 'rendering' stamp: 'len 1/17/2017 18:28:13'!
colorAt: anIntersection
	^Float32Color3 white! !

!TextureWithFinish methodsFor: 'rendering'!
colorAt: anIntersection
	^self finish colorAt: anIntersection! !

!TextureWithFinish methodsFor: 'accessing'!
finish
	^finish! !

!TextureWithFinish methodsFor: 'accessing'!
finish: anObject
	finish _ anObject! !

!TextureWithFinish methodsFor: 'initializing'!
initialize
	self
		pigment: FlatColorPigment new;
		finish: PhongLightingModelFinish new! !

!TextureWithFinish methodsFor: 'accessing'!
pigment
	^pigment! !

!TextureWithFinish methodsFor: 'accessing'!
pigment: anObject
	pigment _ anObject! !
