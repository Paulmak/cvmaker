//
//  EditView.swift
//  cvmaker
//
//  Created by Pavel on 30.09.2025.
//

import UIKit

protocol EditViewDelegate: AnyObject {
    func editView(_ view: EditView, didUpdateField field: FieldType)
    func editViewDidTapChooseImage(_ view: EditView)
    func editViewDidTapChooseDate(_ view: EditView)
    func editViewDidTapChooseExperience(_ view: EditView)
    func editViewDidTapPreview(_ view: EditView)
}

enum FieldType {
    case firstName(String?)
    case lastName(String?)
    case patronymic(String?)
    case hobbies(String?)
    case phone(String?)
    case mailbox(String?)
    case telegram(String?)
    case specialization(String?)
    case hardSkills(String?)
    case gender(Int)
    case jobStatus(Bool)
    case salary(Float, String)
    case birthdate(String)
    case experience(String)
    case avatar(UIImage?)
}

final class EditView: UIView {
    
    private var formValidator: FormValidator?
    weak var delegate: EditViewDelegate?
    var isDefaultAvatar = true
    
    private lazy var scrollView: ScrollView = {
        let scrollView = ScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: CustomContentView = {
        let contentView = CustomContentView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    lazy var imageView: ImageView = {
        let imageView = ImageView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var segmentedControl: SegmentedControl = {
        let segmentedControl = SegmentedControl()
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private lazy var commonLabelInfo: Label = {
        let label = Label(labelType: .medium)
        label.text = "Общая информация"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var commonInfoStackView: VerticalStackView = {
        let stackView = VerticalStackView(for: .group)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var secondNameTextField: TextField = {
        let textField = TextField(placeholderName: "Фамилия", textFieldType: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var firstNameTextField: TextField = {
        let textField = TextField(placeholderName: "Имя", textFieldType: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var patronymicTextField: TextField = {
        let textField = TextField(placeholderName: "Отчество", textFieldType: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var hobbiesTextView: TextView = {
        let textView = TextView(with: .editable(placeholder: "Увлечения"))
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var birthdayInfoStackView: HorizontalStackView = {
        let stackView = HorizontalStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var birthdateLabel: Label = {
        let label = Label(labelType: .regular)
        label.text = "Дата рождения"
        return label
    }()
    
    private lazy var birthdayButton: ActionButton = {
        let button = ActionButton()
        button.setTitle("Выбрать", for: .normal)
        button.addTarget(self, action: #selector(didTapChooseBirthday), for: .touchUpInside)
        return button
    }()
    
    private lazy var contactsLabelInfo: Label = {
        let label = Label(labelType: .medium)
        label.text = "Контактная информация"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contactsInfoStackView: VerticalStackView = {
        let stackView = VerticalStackView(for: .group)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var phoneNumberTextField: TextField = {
        let textField = TextField(placeholderName: "Номер телефона для связи", textFieldType: .phone)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var mailboxTextField: TextField = {
        let textField = TextField(placeholderName: "Почта", textFieldType: .email)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var telegramAccountTextField: TextField = {
        let textField = TextField(placeholderName: "telegram", textFieldType: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var jobseekersLabelInfo: Label = {
        let label = Label(labelType: .medium)
        label.text = "Для соискателей"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var jobseekersInfoStackView: VerticalStackView = {
        let stackView = VerticalStackView(for: .group)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var specializationTextField: TextField = {
        let textField = TextField(placeholderName: "Специализация", textFieldType: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var hardSkillsTextView: TextView = {
        let textView = TextView(with: .editable(placeholder: "Hard Skills"))
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var jobExperienceInfoStackView: HorizontalStackView = {
        let stackView = HorizontalStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var experienceLabel: Label = {
        let label = Label(labelType: .regular)
        label.text = "Опыт работы"
        return label
    }()
    
    private lazy var experienceButton: ActionButton = {
        let button = ActionButton()
        button.setTitle("Выбрать", for: .normal)
        button.addTarget(self, action: #selector(didTapExperienceButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var sphereView: SphereView = {
        let view = SphereView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var jobStatusStackView: HorizontalStackView = {
        let stackView = HorizontalStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var jobStatusLabel: Label = {
        let label = Label(labelType: .regular)
        label.text = "Открыт к предложениям"
        return label
    }()
    
    private lazy var jobStatusSwitch: Switch = {
        let statusSwitch = Switch()
        statusSwitch.addTarget(self, action: #selector(jobStatusSwitchChanged), for: .valueChanged)
        return statusSwitch
    }()
    
    private lazy var salaryLabel: Label = {
        let label = Label(labelType: .regular)
        label.text = "Зарплатные ожидания"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var salarySlider: Slider = {
        let slider = Slider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        return slider
    }()
    
    private lazy var salaryAmountLabel: Label = {
        let label = Label(labelType: .customLabel(labelTextName: "TTNorms-Medium", labelSize: 24))
        let minSalary = Int(salarySlider.minimumValue)
        label.text = "\(minSalary.formatted(.number.grouping(.automatic))) ₽"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var previewButton: PreviewButton = {
        let button = PreviewButton(customButtonType: .disabled)
        button.setTitle("Посмотреть визитку", for: .normal)
        button.addTarget(self, action: #selector(openPreview), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorAssets.backgroundVcColor
        configureSubviews()
        configureConstraints()
        setupFormValidator()
        setupAllTextCallbacks()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        setupScrollViewHierarchy()
        setupCommonInfoSection()
        setupContactsSection()
        setupJobSeekersSection()
    }
    
    private func setupScrollViewHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func setupCommonInfoSection() {
        contentView.addSubview(imageView)
        contentView.addSubview(segmentedControl)
        contentView.addSubview(commonLabelInfo)
        contentView.addSubview(commonInfoStackView)
        contentView.addSubview(birthdayInfoStackView)
        
        commonInfoStackView.addArrangedSubview(secondNameTextField)
        commonInfoStackView.addArrangedSubview(firstNameTextField)
        commonInfoStackView.addArrangedSubview(patronymicTextField)
        commonInfoStackView.addArrangedSubview(hobbiesTextView)
        
        birthdayInfoStackView.addArrangedSubview(birthdateLabel)
        birthdayInfoStackView.addArrangedSubview(birthdayButton)
    }
    
    private func setupContactsSection() {
        contentView.addSubview(contactsLabelInfo)
        contentView.addSubview(contactsInfoStackView)
        
        contactsInfoStackView.addArrangedSubview(phoneNumberTextField)
        contactsInfoStackView.addArrangedSubview(mailboxTextField)
        contactsInfoStackView.addArrangedSubview(telegramAccountTextField)
    }
    
    private func setupJobSeekersSection() {
        contentView.addSubview(jobStatusStackView)
        contentView.addSubview(jobseekersLabelInfo)
        contentView.addSubview(jobseekersInfoStackView)
        contentView.addSubview(jobExperienceInfoStackView)
        contentView.addSubview(sphereView)
        contentView.addSubview(previewButton)
        sphereView.addSubview(salarySlider)
        sphereView.addSubview(salaryLabel)
        sphereView.addSubview(salaryAmountLabel)
        
        jobseekersInfoStackView.addArrangedSubview(specializationTextField)
        jobseekersInfoStackView.addArrangedSubview(hardSkillsTextView)
        jobExperienceInfoStackView.addArrangedSubview(experienceLabel)
        jobExperienceInfoStackView.addArrangedSubview(experienceButton)
        
        jobStatusStackView.addArrangedSubview(jobStatusLabel)
        jobStatusStackView.addArrangedSubview(jobStatusSwitch)
    }
    
    private func configureConstraints() {
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            
            segmentedControl.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25),
            segmentedControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 32),
            segmentedControl.widthAnchor.constraint(equalToConstant: 228),
            
            commonLabelInfo.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 30),
            commonLabelInfo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            commonInfoStackView.topAnchor.constraint(equalTo: commonLabelInfo.bottomAnchor, constant: 20),
            commonInfoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            commonInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            birthdayInfoStackView.topAnchor.constraint(equalTo: commonInfoStackView.bottomAnchor, constant: 30),
            birthdayInfoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35),
            birthdayInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -35),
            
            contactsLabelInfo.topAnchor.constraint(equalTo: birthdayInfoStackView.bottomAnchor, constant: 40),
            contactsLabelInfo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            contactsInfoStackView.topAnchor.constraint(equalTo: contactsLabelInfo.bottomAnchor, constant: 20),
            contactsInfoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contactsInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            jobseekersLabelInfo.topAnchor.constraint(equalTo: contactsInfoStackView.bottomAnchor, constant: 30),
            jobseekersLabelInfo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            jobseekersInfoStackView.topAnchor.constraint(equalTo: jobseekersLabelInfo.bottomAnchor, constant: 20),
            jobseekersInfoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            jobseekersInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            jobExperienceInfoStackView.topAnchor.constraint(equalTo: jobseekersInfoStackView.bottomAnchor, constant: 20),
            jobExperienceInfoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35),
            jobExperienceInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -35),
            
            sphereView.topAnchor.constraint(equalTo: jobExperienceInfoStackView.bottomAnchor, constant: 20),
            sphereView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sphereView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            salaryLabel.topAnchor.constraint(equalTo: sphereView.topAnchor, constant: 20),
            salaryLabel.leadingAnchor.constraint(equalTo: sphereView.leadingAnchor, constant: 16),
            salaryLabel.bottomAnchor.constraint(equalTo: salarySlider.topAnchor, constant: -20),
            
            salaryAmountLabel.topAnchor.constraint(equalTo: sphereView.topAnchor, constant: 20),
            salaryAmountLabel.trailingAnchor.constraint(equalTo: sphereView.trailingAnchor, constant: -16),
            salaryAmountLabel.bottomAnchor.constraint(equalTo: salarySlider.topAnchor, constant: -20),
            
            salarySlider.leadingAnchor.constraint(equalTo: sphereView.leadingAnchor, constant: 16),
            salarySlider.trailingAnchor.constraint(equalTo: sphereView.trailingAnchor, constant: -16),
            salarySlider.bottomAnchor.constraint(equalTo: sphereView.bottomAnchor, constant: -20),
            
            jobStatusStackView.topAnchor.constraint(equalTo: sphereView.bottomAnchor, constant: 30),
            jobStatusStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35),
            jobStatusStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -35),
            
            previewButton.topAnchor.constraint(equalTo: jobStatusStackView.bottomAnchor, constant: 40),
            previewButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            previewButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            previewButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupAllTextCallbacks() {
        setupTextFieldCallbacks()
        setupTextViewCallbacks()
        
    }
    
    private func setupTextFieldCallbacks() {
        firstNameTextField.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            self.delegate?.editView(self, didUpdateField: .firstName(text))
        }
        
        secondNameTextField.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            self.delegate?.editView(self, didUpdateField: .lastName(text))
        }
        
        patronymicTextField.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            self.delegate?.editView(self, didUpdateField: .patronymic(text))
        }
        
        phoneNumberTextField.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            self.delegate?.editView(self, didUpdateField: .phone(text))
        }
        
        mailboxTextField.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            self.delegate?.editView(self, didUpdateField: .mailbox(text))
        }
        
        telegramAccountTextField.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            self.delegate?.editView(self, didUpdateField: .telegram(text))
        }
        
        specializationTextField.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            self.delegate?.editView(self, didUpdateField: .specialization(text))
        }
    }
    
    private func setupTextViewCallbacks() {
        hobbiesTextView.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            self.delegate?.editView(self, didUpdateField: .hobbies(text))
        }
        
        hardSkillsTextView.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            self.delegate?.editView(self, didUpdateField: .hardSkills(text))
        }
    }
    
    private func setupFormValidator() {
        let mandatoryFields = [
            secondNameTextField,
            firstNameTextField,
            phoneNumberTextField,
            specializationTextField
        ]
        
        formValidator = FormValidator(
            textFields: mandatoryFields
        ) { [weak self] isValid in
            self?.previewButton.isEnabled = isValid
            self?.previewButton.alpha = isValid ? 1.0 : 0.5
        }
    }
    
    func setAvatarImage(_ image: UIImage?) {
        if let image = image {
            imageView.image = image
            isDefaultAvatar = false
        } else {
            let defaultImage = AvatarProvider.image(for: segmentedControl.selectedSegmentIndex)
            imageView.image = defaultImage
            isDefaultAvatar = true
        }
    }
    
    private func setupBinding(for textField: TextField, field: FieldType) {
        textField.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            self.delegate?.editView(self, didUpdateField: field)
        }
    }
    
    private func setupBinding(for textView: TextView, field: FieldType) {
        textView.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            self.delegate?.editView(self, didUpdateField: field)
        }
    }
    
    func configure(with viewModel: EditViewModel) {
        segmentedControl.selectedSegmentIndex = viewModel.genderIndex
        
        let avatarData = viewModel.avatarData
        setAvatarImage(avatarData.image)
        
        setValue(.firstName(viewModel.profile.firstName))
        setValue(.lastName(viewModel.profile.lastName))
        setValue(.patronymic(viewModel.profile.patronymic))
        setValue(.hobbies(viewModel.profile.hobbies))
        
        setValue(.birthdate(viewModel.birthdateString))
        setValue(.experience(viewModel.experienceString))
        
        setValue(.phone(viewModel.profile.phone))
        setValue(.mailbox(viewModel.profile.email))
        setValue(.telegram(viewModel.profile.telegram))
        
        setValue(.specialization(viewModel.profile.specialization))
        setValue(.hardSkills(viewModel.profile.hardSkills))
        
        setValue(.salary(viewModel.salaryValue, viewModel.formattedSalary))
        setValue(.jobStatus(viewModel.jobStatus))
        
        previewButton.isEnabled = viewModel.isFormValid
        previewButton.alpha = viewModel.isFormValid ? 1.0 : 0.5
    }
    
    func setValue(_ field: FieldType) {
        switch field {
        case .avatar(let image):
            setAvatarImage(image)
        case .firstName(let text):
            firstNameTextField.text = text
        case .lastName(let text):
            secondNameTextField.text = text
        case .patronymic(let text):
            patronymicTextField.text = text
        case .hobbies(let text):
            hobbiesTextView.text = text
        case .phone(let text):
            phoneNumberTextField.text = text
        case .mailbox(let text):
            mailboxTextField.text = text
        case .telegram(let text):
            telegramAccountTextField.text = text
        case .specialization(let text):
            specializationTextField.text = text
        case .hardSkills(let text):
            hardSkillsTextView.text = text
        case .gender(let index):
            segmentedControl.selectedSegmentIndex = index
        case .jobStatus(let isOn):
            jobStatusSwitch.isOn = isOn
        case .salary(let value, let label):
            salarySlider.value = value
            salaryAmountLabel.text = label
        case .birthdate(let text):
            birthdayButton.setTitle(text, for: .normal)
        case .experience(let text):
            experienceButton.setTitle(text, for: .normal)
        }
    }
    
    func setGender(_ genderIndex: Int) {
        segmentedControl.selectedSegmentIndex = genderIndex
    }
    
    func setSalary(_ value: Float, salaryLabel: String) {
        salarySlider.value = value
        salaryAmountLabel.text = salaryLabel
        
    }
    
    func setJobStatus(_ value: Bool) {
        jobStatusSwitch.isOn = value
    }
    
    func validateForm() {
        formValidator?.forceValidation()
    }
    
    @objc
    private func segmentedControlChanged(_ sender: UISegmentedControl) {
        delegate?.editView(self, didUpdateField: .gender(sender.selectedSegmentIndex))
        
        if isDefaultAvatar {
            imageView.image = AvatarProvider.image(for: sender.selectedSegmentIndex)
        }
    }
    
    @objc
    private func sliderValueChanged(_ sender: UISlider) {
        let salaryLabel = "\(SalaryFormatter.formatted(Int(sender.value)))"
        salaryAmountLabel.text = salaryLabel
        delegate?.editView(self, didUpdateField: .salary(sender.value, salaryLabel))
    }
    
    @objc
    private func didTapChooseBirthday() {
        delegate?.editViewDidTapChooseDate(self)
    }
    
    @objc
    private func didTapExperienceButton() {
        delegate?.editViewDidTapChooseExperience(self)
    }
    
    @objc
    private func imageTapped() {
        delegate?.editViewDidTapChooseImage(self)
    }
    
    @objc
    private func jobStatusSwitchChanged(_ sender: UISwitch) {
        delegate?.editView(self, didUpdateField: .jobStatus(sender.isOn))
    }
    
    @objc
    private func openPreview() {
        delegate?.editViewDidTapPreview(self)
    }
}
