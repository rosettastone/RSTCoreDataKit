Pod::Spec.new do |s|
	s.name				= 'RSTCoreDataKit'
	s.version			= '0.1.2'
	s.summary			= 'A simpler CoreData stack'
	s.homepage			= 'https://github.com/rosettastone/RSTCoreDataKit'
	s.license			= 'BSD 3.0'
	s.authors			= 'Rosetta Stone'
	s.source			= { :git => 'https://github.com/rosettastone/RSTCoreDataKit.git', :tag => s.version.to_s }
	s.platform			= :ios, '8.0'
	s.source_files		= 'RSTCoreDataKit/*.{h,m}'
	s.frameworks		= 'CoreData', 'UIKit', 'Foundation'
	s.requires_arc		= true
end