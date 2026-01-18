//
//  EditView.swift
//  cvmaker
//
//  Created by Pavel on 30.09.2025.
//

import UIKit

protocol EditViewDelegate: AnyObject {
    func editView<T>(_ view: EditView, didUpdate keyPath: WritableKeyPath<ProfileModel, T?>, value: T?)
    func editViewDidTapChooseImage(_ view: EditView)
    func editViewDidTapChooseDate(_ view: EditView)
    func editViewDidTapChooseExperience(_ view: EditView)
    func editViewDidTapPreview(_ view: EditView)
}

final class EditView: UIView {
    
    private var formValidator: FormValidator?
    private var birtdayFormatter: BirthDateFormatter?
    weak var delegate: EditViewDelegate?
    var isDefaultAvatar = true
    var currentAvatarImage: UIImage? {
        imageView.image
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var imageView: ImageView = {
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
    
    private lazy var commonInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 15
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
    
    private lazy var birthdayInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 15
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
    
    private lazy var contactsInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 15
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
    
    private lazy var jobseekersInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 15
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
    
    private lazy var jobExperienceInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 15
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
    
    private lazy var jobStatusStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 15
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
        setupCallbacks()
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
    
    func setProfile(with profile: ProfileModel, avatar: UIImage?) {
        setFirstName(profile.firstName)
        setLastName(profile.lastName)
        setPatronymic(profile.patronymic)
        setPhone(profile.phone)
        setMailbox(profile.email)
        setTelegram(profile.telegram)
        setSpecialization(profile.specialization)
        setHobbies(profile.hobbies)
        setHardSkills(profile.hardSkills)
        setSalary(Int(profile.salary ?? 60000))
        setJobStatus(profile.isOpenToOffers ?? false)
        setGender(profile.genderIndex ?? 0)
        setBirthdate(profile.birthdate)
        setExperience(profile.experience)
        setAvatarImage(avatar)
        formValidator?.forceValidation()
    }
    
    func setFirstName(_ text: String?) { firstNameTextField.text = text }
    func setLastName(_ text: String?) { secondNameTextField.text = text }
    func setPatronymic(_ text: String?) { patronymicTextField.text = text }
    func setPhone(_ text: String?) { phoneNumberTextField.text = text }
    func setMailbox(_ text: String?) { mailboxTextField.text = text }
    func setTelegram(_ text: String?) { telegramAccountTextField.text = text }
    func setSpecialization(_ text: String?) { specializationTextField.text = text }
    func setHobbies(_ text: String?) { hobbiesTextView.text = text }
    func setHardSkills(_ text: String?) { hardSkillsTextView.text = text }
    func setSalary(_ value: Int) {
        salarySlider.value = Float(value)
        salaryAmountLabel.text = "\(SalaryFormatter.formatted(value))"
    }
    func setJobStatus(_ isOpen: Bool) { jobStatusSwitch.isOn = isOpen }
    func setGender(_ index: Int) { segmentedControl.selectedSegmentIndex = index }
    func setBirthdate(_ date: Date?) {
        let text = date.flatMap { BirthDateFormatter.format($0) } ?? "Выбрать"
            birthdayButton.setTitle(text, for: .normal)
    }
    func setExperience(_ experience: String?) {
        guard let experience else {
            experienceButton.setTitle("Выбрать", for: .normal)
            return
        }
        
        experienceButton.setTitle(
            experience,
            for: .normal
        )
    }
    
    private func setupCallbacks() {
        firstNameTextField.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            self.delegate?.editView(self, didUpdate: \.firstName, value: text)
        }
        
        secondNameTextField.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            self.delegate?.editView(self, didUpdate: \.lastName, value: text)
        }
        
        patronymicTextField.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            self.delegate?.editView(self, didUpdate: \.patronymic, value: text)
        }
        
        phoneNumberTextField.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            self.delegate?.editView(self, didUpdate: \.phone, value: text)
        }
        
        mailboxTextField.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            self.delegate?.editView(self, didUpdate: \.email, value: text)
        }
        
        telegramAccountTextField.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            self.delegate?.editView(self, didUpdate: \.telegram, value: text)
        }
        
        specializationTextField.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            self.delegate?.editView(self, didUpdate: \.specialization, value: text)
        }
        
        hobbiesTextView.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            self.delegate?.editView(self, didUpdate: \.hobbies, value: text)
        }
        
        hardSkillsTextView.onTextChanged = { [weak self] text in
            guard let self = self else { return }
            self.delegate?.editView(self, didUpdate: \.hardSkills, value: text)
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
    
    @objc
    private func segmentedControlChanged(_ sender: UISegmentedControl) {
        delegate?.editView(self, didUpdate: \.genderIndex, value: sender.selectedSegmentIndex)
        
        if isDefaultAvatar {
            imageView.image = AvatarProvider.image(for: sender.selectedSegmentIndex)
        }
    }
    
    @objc
    private func sliderValueChanged(_ sender: UISlider) {
        delegate?.editView(self, didUpdate: \.salary, value: sender.value)
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
        delegate?.editView(self, didUpdate: \.isOpenToOffers, value: sender.isOn)
    }
    
    @objc
    private func openPreview() {
        delegate?.editViewDidTapPreview(self)
    }
}
