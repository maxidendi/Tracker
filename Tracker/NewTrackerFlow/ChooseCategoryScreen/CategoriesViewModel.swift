import Foundation

final class CategoriesViewModel: CategoryViewModelProtocol {
    
    //MARK: - Init
    
    init(dataProvider: DataProviderProtocol, category: String?) {
        self.dataProvider = dataProvider
        self.dataProvider.categoriesDelegate = self
        self.category = category
    }
    
    //MARK: - Properties
    
    var onCategoriesListStateChange: ((CategoryIndexes) -> Void)?
    private var category: String?
    private var dataProvider: DataProviderProtocol
    weak var delegate: CategoryViewModelDelegate?
    
    //MARK: - Methods
    
    func categoriesList() -> [String] {
        dataProvider.getCategoriesList()
    }
    
    func isCellMarked(at indexPath: IndexPath) -> Bool {
        categoriesList()[indexPath.row] == category
    }
    
    func deleteCategory(at indexPath: IndexPath) {
        if categoriesList()[indexPath.row] == category {
            category = nil
            delegate?.didSelectCategory(category, isSelected: false)
        }
        dataProvider.removeCategory(indexPath)
    }
    
    func selectCategory(_ indexPath: IndexPath) {
        let category = categoriesList()[indexPath.row]
        self.category = category
        delegate?.didSelectCategory(category, isSelected: true)
    }
    
    func getDataProvider() -> DataProviderProtocol {
        dataProvider
    }
    
    func setupAddCategoryViewModel(viewType: AddCategoryViewType) -> AddCategoryViewModelProtocol {
        AddCategoryViewModel(dataProvider: dataProvider, viewType: viewType)
    }
}

//MARK: - Extensions

extension CategoriesViewModel: CategoriesDelegate {
    func categoriesDidChange(_ indexes: CategoryIndexes) {
        onCategoriesListStateChange?(indexes)
    }
}


