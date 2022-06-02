# TDTagSearch (in development)

The [PeerWalk app](https://www.tapdigital.com/peerwalk.html) is designed to enable rapid ad hoc peer code reviews. A feature of the app allows user to tag a defect from a list. The taxonomy of this list (tree) is publicly scrutable. This allows customers to give feedback, suggest or fix the defect tag tree. This xcode project is imported into the PeerWalk app via Swift Package Manager (SPM). In addition to just the data tree, this repo gives back to the community the SwiftUI code for the entire tagging UI within PeerWalk.

![screenshot](https://github.com/elprl/TDTagSearch/blob/master/Sources/TDTagSearch/Excludes/screenshot.png)

### Adapted from   
[https://github.com/giiiita/TagLayoutView](https://github.com/giiiita/TagLayoutView)

## Tag Tree
The data structure for all the defect tags is a JSON file located here: [tags.json](https://github.com/elprl/TDTagSearch/blob/master/Sources/TDTagSearch/Resources/tags.json). Please give feedback and suggestions either via the [Issues](https://github.com/elprl/TDTagSearch/issues) tab or with Pull Requests. Parent tags (or categories) required to end with a forward slash (e.g. "Architecture/"), usable (child) tags must not (e.g. "Architecture/Patterns/Creational/Builder"). For example:

```json
[
  "Architecture/",
  "Architecture/Patterns/",
  "Architecture/Patterns/Creational/",
  "Architecture/Patterns/Creational/Abstract factory",
  "Architecture/Patterns/Creational/Builder",
]
```

## How to use
- Install via SPM - File -> Add Packages... -> https://github.com/elprl/TDTagSearch .
- Add a **tags.json** file to your project in the format mentioned above.  
- Observe the view model for changes.

### Example Code
```swift
import TDTagSearch 

struct ContentView: View {
    @StateObject var viewModel: TDTagSearchViewModel
    let myTags = Bundle.main.path(forResource: "tags", ofType: "json")
    
    var body: some View {
        TDTagSearchRouter().build(viewModel: viewModel, tagFilePath: myTags)
            .onChange(of: viewModel.hasFinished) { hasFinished in
                debugPrint(viewModel.filteredTags)
                debugPrint(viewModel.selectedTags)
                debugPrint(hasFinished)
            }
    }
}
```
