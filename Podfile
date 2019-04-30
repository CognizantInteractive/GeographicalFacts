platform :ios, '10.0'

workspace 'GeographicalFacts'

def shared_pods
    pod 'Alamofire', '~> 4.5'
    pod 'SwiftLint'
end

target 'GeographicalFacts' do
project 'GeographicalFacts.xcodeproj'
use_frameworks!

shared_pods

target 'GeographicalFactsTests' do
inherit! :search_paths
# Pods for testing
end
end
