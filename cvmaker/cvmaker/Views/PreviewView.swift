//
//  PreviewView.swift
//  cvmaker
//
//  Created by Pavel on 03.11.2025.
//

import UIKit

protocol PreviewViewDelegate: AnyObject {
    func previewViewDidTapShare(_ view: PreviewView, screenshot: UIImage)
}

enum PreviewField {
    case avatar(image: UIImage?, genderIndex: Int?)
    case profileName(String)
    case profileGender(String)
    case profileAge(String)
    case jobStatus(text: String, image: UIImage)
    case phone(String)
    case email(String)
    case telegram(String)
    case name(String)
    case gender(String)
    case birthDate(String)
    case hobbies(String)
    case specialization(String)
    case experience(String)
    case salary(String)
    case hardSkills(String)
}

final class PreviewView: UIView {
    
    weak var delegate: PreviewViewDelegate?
    
    private lazy var scrollView: ScrollView = {
        let scrollView = ScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let mainVerticalStackView: VerticalStackView = {
        let stack = VerticalStackView(for: .main)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let upperProfileInfoHorizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .top
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var imageView: ImageView = {
        let imageView = ImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleVerticalStackView: VerticalStackView = {
        let stack = VerticalStackView(for: .keyValue)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var profileNameLabel: Label = {
        let label = Label(labelType: .large)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var genderAndAgeHorizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var profileGenderLabel: Label = {
        let label = Label(labelType: .regular)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var profileAgeLabel: Label = {
        let label = Label(labelType: .regular)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var jobStatusHorizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var jobStatusLabel: Label = {
        let label = Label(labelType: .regular)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var jobStatusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private lazy var contactInformationVerticalStackView: VerticalStackView = {
        let verticalStackView = VerticalStackView(for: .group)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        return verticalStackView
    }()
    
    private lazy var phoneInformationHorizontalStackView: HorizontalStackView = {
        let horizontalStackView = HorizontalStackView()
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        return horizontalStackView
    }()
    
    private lazy var emailInformationHorizontalStackView: HorizontalStackView = {
        let horizontalStackView = HorizontalStackView()
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        return horizontalStackView
    }()
    
    private lazy var telegramInformationHorizontalStackView: HorizontalStackView = {
        let horizontalStackView = HorizontalStackView()
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        return horizontalStackView
    }()
    
    private lazy var phoneNumberLabel: Label = {
        let label = Label(labelType: .regular)
        label.text = "Номер для связи"
        label.textColor = ColorAssets.textFieldPlaceholderColor
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var phoneNumberValueLabel: Label = {
        let label = Label(labelType: .regular)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailLabel: Label = {
        let label = Label(labelType: .regular)
        label.text = "Почта"
        label.textColor = ColorAssets.textFieldPlaceholderColor
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailValueLabel: Label = {
        let label = Label(labelType: .regular)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var telegramLabel: Label = {
        let label = Label(labelType: .regular)
        label.text = "telegram"
        label.textColor = ColorAssets.textFieldPlaceholderColor
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var telegramValueLabel: Label = {
        let label = Label(labelType: .regular)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contactInformationSeparator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Rectangle")
        return imageView
    }()
    
    private lazy var commonInformationVerticalStackView: VerticalStackView = {
        let verticalStackView = VerticalStackView(for: .group)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        return verticalStackView
    }()
    
    private lazy var commonInformationTitle: Label = {
        let label = Label(labelType: .medium)
        label.text = "Общая информация"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var firstAndSecondNameVerticalStackView: VerticalStackView = {
        let verticalStackView = VerticalStackView(for: .keyValue)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        return verticalStackView
    }()
    
    private lazy var firstAndSecondNameLabel: Label = {
        let label = Label(labelType: .regular)
        label.text = "Имя"
        label.textColor = ColorAssets.textFieldPlaceholderColor
        return label
    }()
    
    private lazy var firstAndSecondNameValueLabel: Label = {
        let label = Label(labelType: .regular)
        return label
    }()
    
    private lazy var genderVerticalStackView: VerticalStackView = {
        let verticalStackView = VerticalStackView(for: .keyValue)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        return verticalStackView
    }()
    
    private lazy var genderLabel: Label = {
        let label = Label(labelType: .regular)
        label.text = "Пол"
        label.textColor = ColorAssets.textFieldPlaceholderColor
        return label
    }()
    
    private lazy var genderValueLabel: Label = {
        let label = Label(labelType: .regular)
        return label
    }()
    
    private lazy var birthDateVerticalStackView: VerticalStackView = {
        let verticalStackView = VerticalStackView(for: .keyValue)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        return verticalStackView
    }()
    
    private lazy var birthDateLabel: Label = {
        let label = Label(labelType: .regular)
        label.text = "Дата рождения"
        label.textColor = ColorAssets.textFieldPlaceholderColor
        return label
    }()
    
    private lazy var birthDateValueLabel: Label = {
        let label = Label(labelType: .regular)
        return label
    }()
    
    private lazy var hobbiesVerticalStackView: VerticalStackView = {
        let verticalStackView = VerticalStackView(for: .keyValue)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        return verticalStackView
    }()
    
    private lazy var hobbiesLabel: Label = {
        let label = Label(labelType: .regular)
        label.text = "Увлечения"
        label.textColor = ColorAssets.textFieldPlaceholderColor
        return label
    }()
    
    private lazy var hobbiesValueLabel: TextView = {
        let textView = TextView(with: .preview)
        return textView
    }()
    
    private lazy var commonInformationSeparator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Rectangle")
        return imageView
    }()
    
    private lazy var forJobSeekersTitle: Label = {
        let label = Label(labelType: .medium)
        label.text = "Для соискателей"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var forJobSeekersVerticalStackView: VerticalStackView = {
        let verticalStackView = VerticalStackView(for: .group)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        return verticalStackView
    }()
    
    private lazy var specializationVerticalStackView: VerticalStackView = {
        let verticalStackView = VerticalStackView(for: .keyValue)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        return verticalStackView
    }()
    
    private lazy var specializationLabel: Label = {
        let label = Label(labelType: .regular)
        label.text = "Специализация"
        label.textColor = ColorAssets.textFieldPlaceholderColor
        return label
    }()
    
    private lazy var specializationValueLabel: Label = {
        let label = Label(labelType: .regular)
        return label
    }()
    
    private lazy var experienceVerticalStackView: VerticalStackView = {
        let verticalStackView = VerticalStackView(for: .keyValue)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        return verticalStackView
    }()
    
    private lazy var experienceLabel: Label = {
        let label = Label(labelType: .regular)
        label.text = "Опыт работы"
        label.textColor = ColorAssets.textFieldPlaceholderColor
        return label
    }()
    
    private lazy var experienceValueLabel: Label = {
        let label = Label(labelType: .regular)
        return label
    }()
    
    private lazy var salaryExpectationsVerticalStackView: VerticalStackView = {
        let verticalStackView = VerticalStackView(for: .keyValue)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        return verticalStackView
    }()
    
    private lazy var salaryExpectationsLabel: Label = {
        let label = Label(labelType: .regular)
        label.text = "Зарплатные ожидания"
        label.textColor = ColorAssets.textFieldPlaceholderColor
        return label
    }()
    
    private lazy var salaryExpectationsValueLabel: Label = {
        let label = Label(labelType: .regular)
        return label
    }()
    
    private lazy var hardSkillsVerticalStackView: VerticalStackView = {
        let verticalStackView = VerticalStackView(for: .keyValue)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        return verticalStackView
    }()
    
    private lazy var hardSkillsLabel: Label = {
        let label = Label(labelType: .regular)
        label.text = "Hard skills"
        label.textColor = ColorAssets.textFieldPlaceholderColor
        return label
    }()
    
    private lazy var hardSkillsValueLabel: TextView = {
        let textView = TextView(with: .preview)
        return textView
    }()
    
    private lazy var shareButton: PreviewButton = {
        let button = PreviewButton(customButtonType: .enabled)
        button.setTitle("Поделиться", for: .normal)
        button.addTarget(self, action: #selector(sharePreview), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorAssets.backgroundVcColor
        configureSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScrollViewHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(mainVerticalStackView)
    }
    
    private func setupUpperProfileInfo() {
        mainVerticalStackView.addArrangedSubview(upperProfileInfoHorizontalStackView)
        upperProfileInfoHorizontalStackView.addArrangedSubview(imageView)
        upperProfileInfoHorizontalStackView.addArrangedSubview(titleVerticalStackView)
        
        titleVerticalStackView.addArrangedSubview(profileNameLabel)
        titleVerticalStackView.addArrangedSubview(genderAndAgeHorizontalStackView)
        titleVerticalStackView.setCustomSpacing(20, after: genderAndAgeHorizontalStackView)
        titleVerticalStackView.addArrangedSubview(jobStatusHorizontalStackView)
        
        genderAndAgeHorizontalStackView.addArrangedSubview(profileGenderLabel)
        genderAndAgeHorizontalStackView.addArrangedSubview(profileAgeLabel)
        
        jobStatusHorizontalStackView.addArrangedSubview(jobStatusImageView)
        jobStatusHorizontalStackView.addArrangedSubview(jobStatusLabel)
        
        
    }
    
    private func setupContactInformationSection() {
        mainVerticalStackView.addArrangedSubview(contactInformationVerticalStackView)
        
        contactInformationVerticalStackView.addArrangedSubview(phoneInformationHorizontalStackView)
        phoneInformationHorizontalStackView.addArrangedSubview(phoneNumberLabel)
        phoneInformationHorizontalStackView.addArrangedSubview(phoneNumberValueLabel)
        
        contactInformationVerticalStackView.addArrangedSubview(emailInformationHorizontalStackView)
        emailInformationHorizontalStackView.addArrangedSubview(emailLabel)
        emailInformationHorizontalStackView.addArrangedSubview(emailValueLabel)
        
        contactInformationVerticalStackView.addArrangedSubview(telegramInformationHorizontalStackView)
        telegramInformationHorizontalStackView.addArrangedSubview(telegramLabel)
        telegramInformationHorizontalStackView.addArrangedSubview(telegramValueLabel)
        
        contactInformationVerticalStackView.addArrangedSubview(contactInformationSeparator)
    }
    
    private func setupCommonInformationSection() {
        mainVerticalStackView.addArrangedSubview(commonInformationVerticalStackView)
        commonInformationVerticalStackView.addArrangedSubview(commonInformationTitle)
        commonInformationVerticalStackView.addArrangedSubview(firstAndSecondNameVerticalStackView)
        
        firstAndSecondNameVerticalStackView.addArrangedSubview(firstAndSecondNameLabel)
        firstAndSecondNameVerticalStackView.addArrangedSubview(firstAndSecondNameValueLabel)
        
        commonInformationVerticalStackView.addArrangedSubview(genderVerticalStackView)
        genderVerticalStackView.addArrangedSubview(genderLabel)
        genderVerticalStackView.addArrangedSubview(genderValueLabel)
        
        commonInformationVerticalStackView.addArrangedSubview(birthDateVerticalStackView)
        birthDateVerticalStackView.addArrangedSubview(birthDateLabel)
        birthDateVerticalStackView.addArrangedSubview(birthDateValueLabel)
        
        commonInformationVerticalStackView.addArrangedSubview(hobbiesVerticalStackView)
        hobbiesVerticalStackView.addArrangedSubview(hobbiesLabel)
        hobbiesVerticalStackView.addArrangedSubview(hobbiesValueLabel)
        commonInformationVerticalStackView.addArrangedSubview(commonInformationSeparator)
    }
    
    private func setupJobSeekersInformationSection() {
        mainVerticalStackView.addArrangedSubview(forJobSeekersVerticalStackView)
        forJobSeekersVerticalStackView.addArrangedSubview(forJobSeekersTitle)
        forJobSeekersVerticalStackView.addArrangedSubview(specializationVerticalStackView)
        specializationVerticalStackView.addArrangedSubview(specializationLabel)
        specializationVerticalStackView.addArrangedSubview(specializationValueLabel)
        
        forJobSeekersVerticalStackView.addArrangedSubview(experienceVerticalStackView)
        experienceVerticalStackView.addArrangedSubview(experienceLabel)
        experienceVerticalStackView.addArrangedSubview(experienceValueLabel)
        
        forJobSeekersVerticalStackView.addArrangedSubview(salaryExpectationsVerticalStackView)
        salaryExpectationsVerticalStackView.addArrangedSubview(salaryExpectationsLabel)
        salaryExpectationsVerticalStackView.addArrangedSubview(salaryExpectationsValueLabel)
        
        forJobSeekersVerticalStackView.addArrangedSubview(hardSkillsVerticalStackView)
        hardSkillsVerticalStackView.addArrangedSubview(hardSkillsLabel)
        hardSkillsVerticalStackView.addArrangedSubview(hardSkillsValueLabel)
        
        mainVerticalStackView.addArrangedSubview(shareButton)
    }
    
    private func configureSubviews() {
        setupScrollViewHierarchy()
        setupUpperProfileInfo()
        setupContactInformationSection()
        setupCommonInformationSection()
        setupJobSeekersInformationSection()
    }
    
    private func configureConstraints() {
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            mainVerticalStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            mainVerticalStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            mainVerticalStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            mainVerticalStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            mainVerticalStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            contactInformationVerticalStackView.leadingAnchor.constraint(equalTo: mainVerticalStackView.leadingAnchor, constant: 16),
            contactInformationVerticalStackView.trailingAnchor.constraint(equalTo: mainVerticalStackView.trailingAnchor, constant: -16),
            
            commonInformationVerticalStackView.leadingAnchor.constraint(equalTo: mainVerticalStackView.leadingAnchor, constant: 16),
            commonInformationVerticalStackView.trailingAnchor.constraint(equalTo: mainVerticalStackView.trailingAnchor, constant: -16),
            
            forJobSeekersVerticalStackView.leadingAnchor.constraint(equalTo: mainVerticalStackView.leadingAnchor, constant: 16),
            forJobSeekersVerticalStackView.trailingAnchor.constraint(equalTo: mainVerticalStackView.trailingAnchor, constant: -16),
            forJobSeekersVerticalStackView.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -30),
            
            shareButton.leadingAnchor.constraint(equalTo: mainVerticalStackView.leadingAnchor, constant: 16),
            shareButton.trailingAnchor.constraint(equalTo: mainVerticalStackView.trailingAnchor, constant: -16),
        ])
    }
    
    private func setAvatarImage(_ image: UIImage?, segmentedIndex: Int?) {
        if let image = image {
            imageView.image = image
        } else {
            let defaultImage = AvatarProvider.image(for: segmentedIndex ?? 0)
            imageView.image = defaultImage
        }
    }
    
    func setValue(_ field: PreviewField) {
        switch field {
        case .avatar(let image, let index):
            setAvatarImage(image, segmentedIndex: index)
        case .profileName(let text):
            profileNameLabel.text = text
        case .profileGender(let text):
            profileGenderLabel.text = text
        case .profileAge(let text):
            profileAgeLabel.text = text
        case .jobStatus(let text, let image):
            jobStatusLabel.text = text
            jobStatusImageView.image = image
        case .phone(let text):
            phoneNumberValueLabel.text = text
        case .email(let text):
            emailValueLabel.text = text
        case .telegram(let text):
            telegramValueLabel.text = text
        case .name(let text):
            firstAndSecondNameValueLabel.text = text
        case .gender(let text):
            genderValueLabel.text = text
        case .birthDate(let text):
            birthDateValueLabel.text = text
        case .hobbies(let text):
            hobbiesValueLabel.text = text
        case .specialization(let text):
            specializationValueLabel.text = text
        case .experience(let text):
            experienceValueLabel.text = text
        case .salary(let text):
            salaryExpectationsValueLabel.text = text
        case .hardSkills(let text):
            hardSkillsValueLabel.text = text
        }
    }
    
    func updateFieldVisibility() {
        phoneInformationHorizontalStackView.isHidden = phoneNumberValueLabel.text?.isEmpty ?? true
        emailInformationHorizontalStackView.isHidden = emailValueLabel.text?.isEmpty ?? true
        telegramInformationHorizontalStackView.isHidden = telegramValueLabel.text?.isEmpty ?? true
        
        firstAndSecondNameVerticalStackView.isHidden = firstAndSecondNameValueLabel.text?.isEmpty ?? true
        genderVerticalStackView.isHidden = genderValueLabel.text?.isEmpty ?? true
        birthDateVerticalStackView.isHidden = birthDateValueLabel.text?.isEmpty ?? true
        hobbiesVerticalStackView.isHidden = hobbiesValueLabel.text?.isEmpty ?? true
        
        specializationVerticalStackView.isHidden = specializationValueLabel.text?.isEmpty ?? true
        experienceVerticalStackView.isHidden = experienceValueLabel.text?.isEmpty ?? true
        salaryExpectationsVerticalStackView.isHidden = salaryExpectationsValueLabel.text?.isEmpty ?? true
        hardSkillsVerticalStackView.isHidden = hardSkillsValueLabel.text?.isEmpty ?? true
    }
    
    @objc private func sharePreview() {
        isUserInteractionEnabled = false
        
        let wasButtonHidden = shareButton.isHidden
        
        shareButton.isHidden = true
        
        forceFullLayout(view: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let targetSize = self.mainVerticalStackView.bounds.size
            
            let padding: CGFloat = 40
            let totalSize = CGSize(
                width: targetSize.width,
                height: targetSize.height + padding * 2
            )
            
            let renderer = UIGraphicsImageRenderer(size: totalSize)
            let screenshot = renderer.image { context in
                ColorAssets.backgroundVcColor.setFill()
                context.fill(CGRect(origin: .zero, size: totalSize))
                
                let contentFrame = CGRect(
                    x: 0,
                    y: padding,
                    width: targetSize.width,
                    height: targetSize.height
                )
                self.mainVerticalStackView.drawHierarchy(in: contentFrame, afterScreenUpdates: true)
            }
            
            self.shareButton.isHidden = wasButtonHidden
            self.isUserInteractionEnabled = true
            self.delegate?.previewViewDidTapShare(self, screenshot: screenshot)
        }
    }
    
    private func forceFullLayout(view: UIView) {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        for subview in view.subviews {
            forceFullLayout(view: subview)
        }
    }
}
