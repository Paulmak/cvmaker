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


final class PreviewView: UIView {
    
    weak var delegate: PreviewViewDelegate?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let mainVerticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 30
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
    
    private lazy var titleVerticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 5
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
    
    private lazy var contactInformationVerticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var phoneInformationHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var emailInformationHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var telegramInformationHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
    
    private lazy var commonInformationVerticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var commonInformationTitle: Label = {
        let label = Label(labelType: .medium)
        label.text = "Общая информация"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var firstAndSecondNameVerticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
    
    private lazy var genderVerticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
    
    private lazy var birthDateVerticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
    
    private lazy var hobbiesVerticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
    
    private lazy var forJobSeekersVerticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var specializationVerticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
    
    private lazy var experienceVerticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
    
    private lazy var salaryExpectationsVerticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
    
    private lazy var hardSkillsVerticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
    
    func configure(with state: PreviewViewModel) {
        imageView.image = state.avatar ?? AvatarProvider.image(for: state.genderIndex)
        
        profileNameLabel.text = state.fullName
        profileGenderLabel.text = state.genderAndAge
        
        jobStatusLabel.text = state.jobStatusText
        jobStatusImageView.image = state.jobStatusImage
        
        phoneNumberValueLabel.text = state.phone
        emailValueLabel.text = state.email
        telegramValueLabel.text = state.telegram
        
        firstAndSecondNameValueLabel.text = state.fullName
        genderValueLabel.text = state.gender
        
        birthDateValueLabel.text = state.birthDate
        hobbiesValueLabel.text = state.hobbies
        
        specializationValueLabel.text = state.specialization
        experienceValueLabel.text = state.experience
        salaryExpectationsValueLabel.text = state.salary
        hardSkillsValueLabel.text = state.hardSkills
        
        updateFieldVisibility()
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
