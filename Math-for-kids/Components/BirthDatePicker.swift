import SwiftUI
import UIKit

struct BirthdatePicker: View {
    @State private var selectedDay = 25
    @State private var selectedMonth = 11
    @State private var selectedYear = 2007
    
    var body: some View {
        VStack(spacing: 20) {
            BirthdatePickerView(
                selectedDay: $selectedDay,
                selectedMonth: $selectedMonth,
                selectedYear: $selectedYear
            )
            .frame(height: 216)
        }
    }
    
    private func monthName(_ index: Int) -> String {
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        return months[index]
    }
}

struct BirthdatePickerView: UIViewRepresentable {
    @Binding var selectedDay: Int
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    
    let days = Array(1...31)
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let years = Array(1900...20230).reversed() as [Int]
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        let picker = UIPickerView()
        picker.delegate = context.coordinator
        picker.dataSource = context.coordinator
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        picker.backgroundColor = .clear
        for subview in picker.subviews {
                subview.backgroundColor = .clear
            }
        
        // Set initial selections
        picker.selectRow(selectedDay - 1, inComponent: 0, animated: false)
        picker.selectRow(selectedMonth, inComponent: 1, animated: false)
        if let yearIndex = years.firstIndex(of: selectedYear) {
            picker.selectRow(yearIndex, inComponent: 2, animated: false)
        }
        
        containerView.addSubview(picker)
        
        // Add cyan selection indicator bars
        let topBar = UIView()
        topBar.backgroundColor = UIColor(.brandContent) // #00BCD4
        topBar.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(topBar)
        
        let bottomBar = UIView()
        bottomBar.backgroundColor = UIColor(.brandContent) // #00BCD4
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(bottomBar)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            picker.topAnchor.constraint(equalTo: containerView.topAnchor),
            picker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            
            // Top cyan bar - positioned above selected row
            topBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            topBar.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -32),
            topBar.heightAnchor.constraint(equalToConstant: 3),
            
            // Bottom cyan bar - positioned below selected row
            bottomBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bottomBar.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 32),
            bottomBar.heightAnchor.constraint(equalToConstant: 3)
        ])
        
        context.coordinator.picker = picker
        
        DispatchQueue.main.async {
               self.removePickerBackground(from: picker)
           }
        
        return containerView
    }
    
    private func removePickerBackground(from view: UIView) {
        for subview in view.subviews {
            // Remove background from all subviews
            subview.backgroundColor = .clear
            
            // Recursively check nested views
            if subview.subviews.count > 0 {
                removePickerBackground(from: subview)
            }
            
            // Hide any UIPickerTableView selection overlays
            if String(describing: type(of: subview)).contains("Highlight") ||
               String(describing: type(of: subview)).contains("Selection") {
                subview.isHidden = true
            }
        }
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let picker = context.coordinator.picker else { return }
        
        // Update picker if values change externally
        picker.selectRow(selectedDay - 1, inComponent: 0, animated: true)
        picker.selectRow(selectedMonth, inComponent: 1, animated: true)
        if let yearIndex = years.firstIndex(of: selectedYear) {
            picker.selectRow(yearIndex, inComponent: 2, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        var parent: BirthdatePickerView
        weak var picker: UIPickerView?
        
        init(_ parent: BirthdatePickerView) {
            self.parent = parent
        }
        
        // MARK: - UIPickerViewDataSource
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 3 // Day, Month, Year
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch component {
            case 0: return parent.days.count
            case 1: return parent.months.count
            case 2: return parent.years.count
            default: return 0
            }
        }
        
        // MARK: - UIPickerViewDelegate
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            switch component {
            case 0:
                parent.selectedDay = parent.days[row]
            case 1:
                parent.selectedMonth = row
            case 2:
                parent.selectedYear = parent.years[row]
            default:
                break
            }
            
            // Reload all components to update styling
            pickerView.reloadAllComponents()
        }
        
        // MARK: - Custom Styling
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            switch component {
            case 0: return 100  // Day
            case 1: return 120  // Month
            case 2: return 130  // Year
            default: return 100
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 64
        }
        
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let label = (view as? UILabel) ?? UILabel()
            
            label.textAlignment = .center
            
            switch component {
            case 0:
                label.text = "\(parent.days[row])"
            case 1:
                label.text = parent.months[row]
            case 2:
                label.text = "\(parent.years[row])"
            default:
                label.text = ""
            }
            
            // Check if this row is selected
            let isSelected = pickerView.selectedRow(inComponent: component) == row
            
            if isSelected {
                // Selected styling - Dark navy, larger, bold
                label.textColor = UIColor(.textPrimary) // #1C1E21
                
                // Try to use LilitaOne custom font, fallback to system font
                if let customFont = UIFont(name: "LilitaOne", size: 24) {
                    label.font = customFont
                } else {
                    label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
                }
            } else {
                // Unselected styling - Light gray, smaller
                label.textColor = UIColor(.textInactive) // #A1A7AE
                
                // Try to use LilitaOne custom font, fallback to system font
                if let customFont = UIFont(name: "LilitaOne", size: 20) {
                    label.font = customFont
                } else {
                    label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
                }
            }
            
            return label
        }
    }
}

#Preview {
    BirthdatePicker()
}
