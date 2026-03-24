# OnboardingApp

Тестовое задание: многостраничный онбординг для iOS с сохранением состояния пользователя.

## Технологии

- **Swift 5+**, iOS 15.0+
- **MVVM** + Combine
- **Code-only UI** (Auto Layout Anchors, без Storyboard/XIB)
- **UserDefaults** — сохранение состояния

## Структура проекта

**App/** — AppDelegate, SceneDelegate

**Resources/** — Strings (все текстовые ресурсы)

**Services/** — UserDefaultsService (протокол + реализация)

**Models/** — OnboardingPage (модель слайда)

**Modules/Main/** — MainViewModel, MainViewController

**Modules/Onboarding/** — OnboardingViewModel, OnboardingViewController, OnboardingPageCell

## Функционал

- Главный экран с кнопкой «Показать онбординг»
- После прохождения кнопка меняется на «Добро пожаловать обратно»
- 3 слайда онбординга на UICollectionView с paging
- Все слайды — один переиспользуемый класс OnboardingPageCell
- UIPageControl для индикации страницы
- Кнопка «Далее» → на последнем слайде плавно меняется на «Начать работу»
- Кнопка закрытия (крестик) на всех экранах
- Сохранение флага прохождения в UserDefaults
- Кнопка сброса онбординга

## Усложнения

- Поддержка Dark Mode
- Адаптивность (iPhone SE — iPhone 15 Pro Max)
- Параллакс-анимация при скролле
- Haptic Feedback при нажатии кнопок
- Инкапсулированный сервис UserDefaults через протокол

## Запуск

```bash
git clone https://github.com/DaniilNikonchik/OnboardingApp.git
cd OnboardingApp
open OnboardingApp.xcodeproj
```

Выберите симулятор iPhone 15 (iOS 18.x) → **Cmd + R**
