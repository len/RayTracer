'From Cuis 5.0 of 7 November 2016 [latest update: #3741] on 13 May 2019 at 1:12:43 am'!
'Description Please enter a description for this package'!
!provides: 'RayTracer Examples' 1 2!
!requires: 'RayTracer' 1 0 nil!
SystemOrganization addCategory: #'RayTracer Examples'!


!classDefinition: #Plane category: #'RayTracer Examples'!
RayTraceObject subclass: #Plane
	instanceVariableNames: 'normal offset'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RayTracer Examples'!
!classDefinition: 'Plane class' category: #'RayTracer Examples'!
Plane class
	instanceVariableNames: ''!

!classDefinition: #Sphere category: #'RayTracer Examples'!
RayTraceObject subclass: #Sphere
	instanceVariableNames: 'location radius radiusSquared'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RayTracer Examples'!
!classDefinition: 'Sphere class' category: #'RayTracer Examples'!
Sphere class
	instanceVariableNames: ''!

!classDefinition: #CheckerBoardPigment category: #'RayTracer Examples'!
Object subclass: #CheckerBoardPigment
	instanceVariableNames: 'color1 color2 center squareSize'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RayTracer Examples'!
!classDefinition: 'CheckerBoardPigment class' category: #'RayTracer Examples'!
CheckerBoardPigment class
	instanceVariableNames: ''!

!classDefinition: #RayTraceExamples category: #'RayTracer Examples'!
Object subclass: #RayTraceExamples
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RayTracer Examples'!
!classDefinition: 'RayTraceExamples class' category: #'RayTracer Examples'!
RayTraceExamples class
	instanceVariableNames: ''!

!classDefinition: #WoodPigment category: #'RayTracer Examples'!
Object subclass: #WoodPigment
	instanceVariableNames: 'color1 color2 center ringDistance'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RayTracer Examples'!
!classDefinition: 'WoodPigment class' category: #'RayTracer Examples'!
WoodPigment class
	instanceVariableNames: ''!


!Plane methodsFor: 'initializing'!
initialize
	self
		normal: 0@1@0;
		offset: 0.0! !

!Plane methodsFor: 'initializing' stamp: 'len 1/17/2017 17:40:14'!
writeIntersectionsWith: aRay into: aCollection 
	"A Plane is defined as:
		Ax + By + Cz + D = 0

	A ray is
		origin + (t * direction)

	or:
		(ox + (t * dx)) @ (oy + (t * dy)) @ (oz + (t * dz))

	Substituting into the equation of a plane:
		A(ox + (t*dx)) + B(oy + (t * dy)) + C(oz + (t * dz)) + D = 0

		A ox + A t dx + B oy + B t dy + C oz + C t dz + D = 0
		(A ox + B oy + C oz + D) + t (A dx + B dy + C dz) = 0
		t = -(A ox + B oy + C oz + D) / (A dx + B dy + C dz)"

	| t denominator |
	denominator _ self normal dot: aRay direction.
	denominator abs < 0.0001 ifTrue: [^self].
	t _ ((self normal dot: aRay origin) + offset) negated / denominator.
	t > 0.01 ifTrue: [
		aCollection add: (Intersection 
							for: self
							ray: aRay
							distance: t)]! !

!Plane methodsFor: 'accessing'!
normal
	^normal! !

!Plane methodsFor: 'accessing'!
normal: aVector
	normal _ aVector! !

!Plane methodsFor: 'accessing'!
offset
	^offset! !

!Plane methodsFor: 'accessing' stamp: 'len 1/17/2017 17:42:10'!
offset: aNumber
	offset _ aNumber asFloat! !

!Plane methodsFor: 'tracing'!
normalAt: aPoint
	^normal! !

!Plane class methodsFor: 'instance creation'!
new
	^super new initialize! !

!Sphere methodsFor: 'initializing' stamp: 'len 1/17/2017 18:00:00'!
initialize
	super initialize.
	location _ 0@0@0.
	radius _ 1.0.! !

!Sphere methodsFor: 'accessing'!
location
	^location! !

!Sphere methodsFor: 'accessing'!
location: aVector
	location _ aVector! !

!Sphere methodsFor: 'accessing'!
radius
	^radius! !

!Sphere methodsFor: 'accessing' stamp: 'len 1/17/2017 17:42:17'!
radius: aNumber
	radius _ aNumber asFloat! !

!Sphere methodsFor: 'tracing' stamp: 'len 1/18/2017 21:35:20'!
normalAt: aPoint
	^self location unitVectorTowards: aPoint! !

!Sphere methodsFor: 'tracing'!
radiusSquared
	radiusSquared notNil ifTrue: [^radiusSquared].
	^radiusSquared _ radius * radius! !

!Sphere methodsFor: 'tracing' stamp: 'len 1/17/2017 18:10:43'!
writeIntersectionsWith: aRay into: aCollection 
	"A Sphere is defined as:
		(x - cx)^2 + (y - cy)^2 + (z-cz)^2 = radius^2

	A ray is
		origin + (t * direction)

	or:
		(ox + (t * dx)) @ (oy + (t * dy)) @ (oz + (t * dz))

	Substituting into the equation of a sphere:
		(ox + (t * dx) - cx) ^2 + (oy + (t * dy) - cy) ^2 + (oz + (t * dz) - cz) ^2 = radius^2

		(ox-cx)^2 + (2 * (ox-cx) * t * dx) + (t^2 * dx^2)
			+ (oy-cy)^2 + (2 * (oy-cy) * t * dy) + (t^2 * dy^2)
			+ (oz-cz)^2 + (2 * (oz-cz) * t * dz) + (t^2 * dz^2) = r^2

		t^2 (dx^2 + dy^2 + dz^2) + t (2*(ox-cx) *dx + 2*(oy-cy) *dy + 2*(oz-cz) *dz) + ((ox-cx)^2 + (oy-cy)^2 + (oz-cz)^2 - r^2) = 0

		if we let:
			A = dx^2 + dy^2 + dz^2
			B = 2*(ox-cx)*dx + 2*(oy-cy)*dy + 2*(oz-cz)*dz
			C = (ox-cx)^2 + (oy-cy)^2 + (oz-cz)^2 - r^2

		We have the form:
			A t^2 + B t + C = 0

		the solutions for this equation are:
			t = -B - sqrt(B^2 - 4AC) / 2A
			t = -B + sqrt(B^2 - 4AC) / 2A"

	| a b c determinant t1 t2 originMinusCenter |
	originMinusCenter _ aRay origin - self location.
	a _ aRay directionLengthSquared.
	b _ (originMinusCenter dot: aRay direction) * 2.0.
	c _ (originMinusCenter dot: originMinusCenter) - self radiusSquared.
	determinant _ b * b - (4.0 * a * c).
	determinant < 0.0 ifTrue: [^self].
	determinant _ determinant sqrt.
	t1 _ (b negated + determinant) / (2.0 * a).
	t2 _ (b negated - determinant) / (2.0 * a).
	t1 > 0.01
		ifTrue: 
			[aCollection add: (Intersection 
						for: self
						ray: aRay
						distance: t1)].
	t2 > 0.01
		ifTrue: 
			[aCollection add: (Intersection 
						for: self
						ray: aRay
						distance: t2)]! !

!CheckerBoardPigment methodsFor: 'accessing'!
center
	^center! !

!CheckerBoardPigment methodsFor: 'accessing'!
center: aVector
	center _ aVector! !

!CheckerBoardPigment methodsFor: 'accessing'!
color1
	^color1! !

!CheckerBoardPigment methodsFor: 'accessing' stamp: 'len 5/13/2019 01:09:26'!
color1: aColor
	color1 _ aColor! !

!CheckerBoardPigment methodsFor: 'accessing'!
color2
	^color2! !

!CheckerBoardPigment methodsFor: 'accessing' stamp: 'len 5/13/2019 01:09:31'!
color2: aColor
	color2 _ aColor! !

!CheckerBoardPigment methodsFor: 'accessing'!
squareSize
	^squareSize! !

!CheckerBoardPigment methodsFor: 'accessing' stamp: 'len 1/17/2017 17:41:27'!
squareSize: aNumber
	squareSize _ aNumber asFloat! !

!CheckerBoardPigment methodsFor: 'rendering'!
colorAt: anIntersection
	| texturePoint xBoolean yBoolean zBoolean |
	texturePoint _ (anIntersection intersectionPoint - self center) / self squareSize.
	xBoolean _ texturePoint x floor even.
	yBoolean _ texturePoint y floor even.
	zBoolean _ texturePoint z floor even.
	^((xBoolean xor: yBoolean) xor: zBoolean)
		ifTrue: [color1]
		ifFalse: [color2]! !

!RayTraceExamples class methodsFor: 'examples' stamp: 'len 5/13/2019 01:11:20'!
example1
	"MessageTally spyOn: [RayTraceExamples example1]"

	| image camera scene |
	camera _ Camera new
				location: 0 @ 2 @ -10;
				direction: 0 @ 0 @ 1;
				up: 0 @ 1 @ 0;
				right: 1.333 @ 0 @ 0;
				imageSize: 640 @ 480.
	scene _ Scene new
				addLightSource: (LightSource new
							location: 10 @ 20 @ -20;
							color: Color white);
				addObject: (Plane new
							normal: 0 @ 1 @ 0;
							offset: 1;
							texture: (TextureWithFinish new
										pigment: (CheckerBoardPigment new
													center: 0 @ 0.1 @ 0;
													color1: Color green;
													color2: Color white;
													squareSize: 1);
										finish: (CompoundFinish new
													addFinish: (PhongLightingModelFinish new
																ambient: 0.2;
																specular: 0;
																specularPower: 20);
													addFinish: (ReflectionFinish new reflection: 1))));
				addObject: (Sphere new
							location: 0 @ 1 @ 0;
							texture: (TextureWithFinish new
										pigment: (WoodPigment new
													color1: Color lightBrown darker;
													color2: Color lightBrown darker * 1.5;
													center: 0 @ 1 @ 0;
													ringDistance: 0.1);
										finish: (PhongLightingModelFinish new
													ambient: 0.2;
													specular: 0.8;
													specularPower: 20)));
				addObject: (Sphere new
							location: 3 @ 1 @ 0;
							radius: 1.5;
							texture: (TextureWithFinish new
										pigment: (FlatColorPigment new color: Color red);
										finish: (PhongLightingModelFinish new
													ambient: 0.2;
													specular: 0.8;
													specularPower: 20)));
				yourself.
	image _ camera renderScene: scene.
	ImageMorph new image: image; openInWorld! !

!RayTraceExamples class methodsFor: 'examples' stamp: 'len 1/17/2017 19:26:05'!
example2
	| image camera scene |
	camera _ Camera new
				location: 0 @ 2 @ -10;
				direction: 0 @ 0 @ 1;
				up: 0 @ 1 @ 0;
				right: 1.333 @ 0 @ 0;
				imageSize: 640 @ 480.
	scene _ Scene new
				addLightSource: (LightSource new
							location: 10 @ 20 @ -20;
							color: Color white);
				addObject: (Plane new
							normal: 0 @ 1 @ 0;
							offset: 1;
							texture: (TextureWithFinish new
										pigment: (CheckerBoardPigment new
													center: 0 @ 0.1 @ 0;
													color1: Color green;
													color2: Color white;
													squareSize: 1);
										finish: (PhongLightingModelFinish new
													ambient: 0.2;
													specular: 0;
													specularPower: 20)));
				addObject: (Sphere new
							location: 3 @ 1 @ 0;
							radius: 1.5;
							texture: (TextureWithFinish new
										pigment: (FlatColorPigment new color: Color red);
										finish: (PhongLightingModelFinish new
													ambient: 0.2;
													specular: 0.8;
													specularPower: 20)));
				yourself.
	image _ camera renderScene: scene.
	ImageMorph new image: image; openInWorld! !

!RayTraceExamples class methodsFor: 'examples' stamp: 'len 5/13/2019 01:11:45'!
example3
	| image camera scene |
	camera _ Camera new
				location: 0 @ 2 @ -10;
				direction: 0 @ 0 @ 1;
				up: 0 @ 1 @ 0;
				right: 1.333 @ 0 @ 0;
				imageSize: 640 @ 480.
	scene _ Scene new
				addLightSource: (LightSource new
							location: 10 @ 5 @ -20;
							color: Color white);
				addObject: (Plane new
							normal: 0 @ 1 @ 0;
							offset: 1;
							texture: (TextureWithFinish new
										pigment: (CheckerBoardPigment new
													center: 0 @ 0.1 @ 0;
													color1: Color green;
													color2: Color white;
													squareSize: 1);
										finish: (CompoundFinish new
													addFinish: (PhongLightingModelFinish new
																ambient: 0.2;
																specular: 0;
																specularPower: 20);
													addFinish: (ReflectionFinish new reflection: 1))));
				addObject: (Sphere new
							location: 0 @ 1 @ 0;
							texture: (TextureWithFinish new
										pigment: (WoodPigment new
													color1: Color lightBrown darker;
													color2: Color lightBrown darker * 1.5;
													center: 0 @ 1 @ 0;
													ringDistance: 0.1);
										finish: (PhongLightingModelFinish new
													ambient: 0.2;
													specular: 0.8;
													specularPower: 20)));
				addObject: (Sphere new
							location: 3 @ 1 @ 0;
							radius: 1.5;
							texture: (TextureWithFinish new
										pigment: (FlatColorPigment new color: Color red);
										finish: (PhongLightingModelFinish new
													ambient: 0.2;
													specular: 0.8;
													specularPower: 20)));
				yourself.
	image _ camera renderScene: scene.
	ImageMorph new image: image; openInWorld! !

!WoodPigment methodsFor: 'accessing'!
center
	^center! !

!WoodPigment methodsFor: 'accessing'!
center: aVector
	center _ aVector! !

!WoodPigment methodsFor: 'accessing'!
color1
	^color1! !

!WoodPigment methodsFor: 'accessing' stamp: 'len 5/13/2019 01:12:11'!
color1: aColor
	color1 _ aColor! !

!WoodPigment methodsFor: 'accessing'!
color2
	^color2! !

!WoodPigment methodsFor: 'accessing' stamp: 'len 5/13/2019 01:12:15'!
color2: aColor
	color2 _ aColor! !

!WoodPigment methodsFor: 'accessing'!
ringDistance
	^ringDistance! !

!WoodPigment methodsFor: 'accessing' stamp: 'len 1/17/2017 17:42:35'!
ringDistance: aNumber
	ringDistance _ aNumber asFloat! !

!WoodPigment methodsFor: 'initializing' stamp: 'len 1/17/2017 17:40:51'!
colorAt: anIntersection
	^(((anIntersection intersectionPoint - center) * (1.0 @ 0.0 @ 1.0)) length / ringDistance) fractionPart > 0.5
		ifTrue: [color1]
		ifFalse: [color2]! !

!WoodPigment methodsFor: 'initializing' stamp: 'len 5/13/2019 01:12:25'!
initialize
	self
		color1: Color black;
		color2: Color white;
		center: 0 @ 0 @ 0;
		ringDistance: 1! !

!WoodPigment class methodsFor: 'instance creating'!
new
	^super new initialize! !
