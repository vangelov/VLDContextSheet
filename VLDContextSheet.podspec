Pod::Spec.new do |s|
  s.name = 'VLDContextSheet'
  s.version = '0.1.0'
  s.license = 'MIT'
  s.summary = 'Context menu similar to the one in the Pinterest iOS app'
  s.homepage = 'https://github.com/vangelov/VLDContextSheet'
  s.authors = 'vangelov'
  s.source = { :git => 'https://github.com/vangelov/VLDContextSheet.git', :tag => s.version }

  s.ios.deployment_target = '7.0'

  s.source_files = 'VLDContextSheet/*.{h,m}'

  s.requires_arc = true
end
