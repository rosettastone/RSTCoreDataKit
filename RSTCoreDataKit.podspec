Pod::Spec.new do |s|
	s.name				= 'RSTCoreDataKit'
	s.version			= '1.0.0'
	s.summary			= 'A simpler CoreData stack'
	s.homepage			= 'https://github.com/rosettastone/RSTCoreDataKit'
	s.license			= 'BSD 3.0'
	s.authors			= { 'Jesse Squires' => 'jsquires@rosettastone.com', 'Don Mowry' => 'dmowry@rosettastone.com' }
	s.social_media_url	= 'https://twitter.com/jesse_squires'
	s.source			= { :git => 'https://github.com/rosettastone/RSTCoreDataKit', :tag => s.version.to_s }
	s.platform			= :ios, '8.0'
	s.source_files		= 'RSTCoreDataKit/RSTCoreDataKit/*.{h,m}'
	s.frameworks		= 'CoreData', 'UIKit', 'Foundation'
	s.requires_arc		= true
end