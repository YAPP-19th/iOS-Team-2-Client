//
//  HistoryWriteViewController.swift
//  Budi
//
//  Created by 인병윤 on 2021/11/25.
//

import UIKit
import CombineCocoa
import Combine
class HistoryWriteViewController: UIViewController {
    private(set) var viewModel: HistoryManagementViewModel
    weak var coordinator: LoginCoordinator?
    private var cancellables = Set<AnyCancellable>()
    @IBOutlet weak var firstTypingView: HistorySingleWriteView!
    @IBOutlet weak var datePickerView: HistoryDateWriteView!
    @IBOutlet weak var secondTypingView: HistorySingleWriteView!
    private var currentButtonTag: Int = 0

    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)

        return button
    }()

    override func viewWillAppear(_ animated: Bool) {
        viewModel.state.selectIndex
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] tag in
                self?.currentButtonTag = tag
                if tag == 1 {
                    self?.firstTypingView.configureText(title: "회사명", placeHolder: "회사명을 입력하세요")
                    self?.secondTypingView.configureText(title: "부서명/직책", placeHolder: "부서명/직책을 입력하세요")
                } else if tag == 2 {
                    self?.firstTypingView.configureText(title: "프로젝트명", placeHolder: "프로젝트 이름을 입력하세요")
                    self?.secondTypingView.configureText(title: "직무/역할", placeHolder: "참여한 역할을 입력하세요")
                    self?.datePickerView.checkButtonRemove()
                }
            })
            .store(in: &cancellables)
    }

    init?(coder: NSCoder, viewModel: HistoryManagementViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("This viewController must be init with viewModel")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        configureLayout()
        setButtonAction()
    }

    private func setButtonAction() {
        doneButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                if self?.currentButtonTag == 1 {
                    self?.viewModel.addCompany(WorkHistory(id: 1, companyName: self?.firstTypingView.singleTextField.text, workTerm: [self?.datePickerView.leftTextField.text ?? "", self?.datePickerView.rightTextField.text ?? ""], department: self?.secondTypingView.singleTextField.text))
                } else {
                    self?.viewModel.addProject(ProjectHistory(projectName: self?.firstTypingView.singleTextField.text, projectTerm: [self?.datePickerView.leftTextField.text ?? "", self?.datePickerView.rightTextField.text ?? ""], projectDepartment: self?.secondTypingView.singleTextField.text))
                }
                self?.viewModel.action.title.send([self?.firstTypingView.singleTextField.text ?? "", self?.secondTypingView.singleTextField.text ?? ""])
                //self.viewModel.mainText.append(self.firstTypingView.singleTextField.text ?? "")
                print(self?.firstTypingView.singleTextField.text ?? "")
                print(self?.secondTypingView.singleTextField.text ?? "")
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }

    private func configureLayout() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
    }

}
