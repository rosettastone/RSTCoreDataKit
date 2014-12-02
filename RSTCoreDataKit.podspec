Pod::Spec.new do |s|
	s.name				= 'RSTCoreDataKit'
	s.version			= '0.1.0'
	s.summary			= 'A simpler CoreData stack'
	s.homepage			= 'https://bitbucket.org/livemocha/rstcoredatakit'
	s.license			= 'BSD 3.0'
	s.authors			= { 'Jesse Squires' => 'jsquires@rosettastone.com', 'Don Mowry' => 'dmowry@rosettastone.com' }
	s.social_media_url	= 'https://twitter.com/jesse_squires'
	s.source			= { :git => 'https://bitbucket.org/livemocha/rstcoredatakit.git', :tag => s.version.to_s }
	s.platform			= :ios, '7.0'	
	s.source_files		= 'RSTCoreDataKit/RSTCoreDataKit/*.{h,m}'
	s.frameworks		= 'CoreData', 'UIKit', 'Foundation'
	s.requires_arc		= true
end