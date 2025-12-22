#  Stack App

Stack is a personal credit card rewards tracker designed to help users understand how much cashback they earn and how much they could have earned using a better card.
The app allows users to add credit cards, log transactions, compare actual vs. potential rewards, and visualize returns through graphs.

Originally, the project planned to integrate Plaid for secure bank linking and real-time transaction retrieval.
However after technical evaluation, I decided to remove Plaid for this version. Plaid requires a full OAuth flow, backend server routing, secure API key management,
and a detailed sandbox configuration that could not be implemented reliably within the project timeframe. Also, handling live financial data involves compliance
considerations outside the scope of this class project. Because of this, all transactions are added manually while still demonstrating the reward-calculation logic the app was designed
for. However, I still switched over to SwiftData for easy migration in the future.

The authentication flow was also simplified. The initial approach used a traditional email + password sign-up and login flow, but maintaining
secure credential storage and proper validation added unnecessary complexity for a non-production academic submission.
Instead, the app now uses Face ID / biometric authentication, which offers a smoother onboarding experience and leverages native iOS security
without storing personal user data. Users are greeted with a splash screen, followed by an automatic Face ID prompt to unlock the app.

This version of Stack focuses on polished UI, functional reward logic, and a realistic demonstration of how credit card optimization apps work.
