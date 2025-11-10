import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 36) {
                    Toggle(isOn: $isDarkMode) {
                        Text("Тёмная тема")
                            .foregroundColor(.primary)
                    }
                    .tint(.blue)
                    .onChange(of: isDarkMode) { newValue in
                        UIApplication.shared.windows.first?.overrideUserInterfaceStyle =
                            newValue ? .dark : .light
                    }
                    
                    NavigationLink(destination: AgreementView()) {
                        HStack {
                            Text("Пользовательское соглашение")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("Black_Universal"))
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .background(Color("tabBarColor"))
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Приложение использует API «Яндекс.Расписания»")
                        .font(.system(size: 13))
                        .foregroundColor(Color("Black_Universal"))
                    Text("Версия 1.0 (beta)")
                        .font(.system(size: 13))
                        .foregroundColor(Color("Black_Universal"))
                }
                .padding(.bottom, 16)
            }
            .navigationTitle("Настройки")
            .background(Color("tabBarColor").ignoresSafeArea())
        }
    }
}

struct AgreementView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color("tabBarColor")
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Оферта на оказание образовательных услуг дополнительного образования Яндекс.Практикум для физических лиц")
                        .font(.system(size: 24, weight: .bold))
                    Text("Данный документ является действующим, если расположен по адресу: https://yandex.ru/legal/practicum_offer")
                        .font(.system(size: 17, weight: .regular))
                    Text("Российская Федерация,город Москва")
                        .font(.system(size: 17, weight: .regular))
                    Text("1.ТЕРМИНЫ")
                        .font(.system(size: 24, weight: .bold))
                    Text("""
                Понятия, используемые в Оферте, означают следующее:  Авторизованные адреса — адреса электронной почты каждой Стороны. Авторизованным адресом Исполнителя является адрес электронной почты, указанный в разделе 11 Оферты. Авторизованным адресом Студента является адрес электронной почты, указанный Студентом в Личном кабинете.  Вводный курс — начальный Курс обучения по представленным на Сервисе Программам обучения в рамках выбранной Студентом Профессии или Курсу, рассчитанный на определенное количество часов самостоятельного обучения, который предоставляется Студенту единожды при регистрации на Сервисе на безвозмездной основе. В процессе обучения в рамках Вводного курса Студенту предоставляется возможность ознакомления с работой Сервиса и определения возможности Студента продолжить обучение в рамках Полного курса по выбранной Студентом Программе обучения. Точное количество часов обучения в рамках Вводного курса зависит от выбранной Студентом Профессии или Курса и определяется в Программе обучения, размещенной на Сервисе. Максимальный срок освоения Вводного курса составляет 1 (один) год с даты начала обучения.
                """)
                    .font(.system(size: 16))
                }
                .padding()
            }
            .navigationTitle("Пользовательское соглашение")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("Black_Universal"))
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}

