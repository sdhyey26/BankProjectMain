## BankProjectMain

A Java Servlet/JSP-based banking management web application with role-based access for Admins and Customers. It provides user registration and authentication, account management, fund transfers, transaction history (passbook), card applications and status tracking, and admin analytics.


## Tech Stack
- Java 8+ (Servlet 3.x annotations)
- JSP (JSTL not required; plain JSP used)
- MySQL 5.7+/8.0+
- JDBC (MySQL Connector/J)
- Tomcat 8.5+/9/10 (any Servlet 3.0+ compatible container)
- Eclipse (project includes `.project`, `.classpath`)


## Project Structure
```
BankProjectMain/
  src/main/java/com/tss/
    controller/           # Servlets (request handling and page routing)
    dao/                  # Data access: users, accounts, transfers, transactions, cards
    model/                # POJOs: User, Account, Transaction, CardApplication
    service/              # Business logic: AuthService, TransferService
    util/                 # DBConnection (JDBC connection factory)
  src/main/webapp/
    admin/                # Admin JSP pages
    customer/             # Customer JSP pages
    css/                  # Styles
    login.jsp, register.jsp, logout.jsp
    WEB-INF/lib/          # Place MySQL JDBC driver here if not provided by container
```


## Key Concepts
- Sessions: After login, the app stores `user` (com.tss.model.User) and `role` (`"Admin"` or `"Customer"`) in session.
- Authorization: Each protected Servlet checks session `role` and redirects to `login.jsp` if unauthorized.
- Persistence: DAOs use plain JDBC via `com.tss.util.DBConnection`.
- Views: JSPs render UI and post back to Servlets.


## Features by Role

### Customer
- Dashboard: Overview of accounts and last transaction summary
- Account info: List all accounts owned by the user
- Transfers: Internal (Savings ↔ Current) and External (to another account)
- Passbook: Filterable transaction history with export (Copy/CSV/Excel/PDF/Print)
- Card services: Apply for a card, view card application status
- Logout

### Admin
- Dashboard: Snapshot of pending card requests, users with accounts, and all accounts
- Manage Users: List users with accounts; edit user profile; delete user
- Manage Accounts: List accounts; edit account type/balance; delete account
- Transactions: Browse all or filter by account number
- Card Requests: Review and approve/reject card applications; filter by status
- Analysis: Account mix, balances by type, monthly accounts/transactions, and top users by total balance
- Logout


## Endpoints (Servlets) and Views

- `LoginServlet` [POST]
  - Params: `username`, `password`, `role` (Admin|Customer)
  - On success: sets session `user`, `role` and redirects to `AdminDashboardServlet` or `CustomerDashboardServlet`
  - On failure: forwards to `login.jsp` with `error`

- `RegisterServlet` [POST]
  - Params: `username`, `password`, `name`, `mobile`, `email`, `aadhar`, `accountType` (Savings|Current), `initialDeposit`
  - Creates/links a `users` row and an initial `accounts` row
  - On success: redirects to `login.jsp`; on failure: forwards to `register.jsp` with `error`

- `CustomerDashboardServlet` [GET]
  - Requires session role `Customer`
  - Loads user accounts and latest transaction summary
  - View: `customer/dashboard.jsp`

- `AccountInfoServlet` [GET]
  - Requires role `Customer`
  - Loads all accounts by user
  - View: `customer/account.jsp`

- `TransferServlet` [GET, POST]
  - [GET] View: `customer/transfers.jsp`
  - [POST] Params: `transferType` (internal|external), `fromType` (Savings|Current), `toAccountNumber` (external only), `amount`
  - Uses `TransferService` for validations and `TransferDAO.transferFunds`
  - Forwards to `customer/transfers.jsp` with `message` or `error`

- `PassbookServlet` [GET]
  - Requires role `Customer`
  - Filters: `type` (credit|debit), `from` (yyyy-mm-dd), `to` (yyyy-mm-dd)
  - View: `customer/passbook.jsp` (DataTables with export buttons)

- `CardApplicationServlet` [GET, POST]
  - Requires role `Customer`
  - [GET] Preloads accounts; View: `customer/apply_card.jsp`
  - [POST] Params: `accountNumber`, `cardType`; persists request via `CardApplicationDAO`

- `CardStatusServlet` [GET]
  - Requires role `Customer`
  - Lists user card applications
  - View: `customer/card_status.jsp`

- `AdminDashboardServlet` [GET]
  - Requires role `Admin`
  - Loads: pending card applications, users with accounts, all accounts
  - View: `admin/dashboard.jsp`

- `ManageUsersServlet` [GET]
  - Requires role `Admin`
  - Lists users with accounts
  - View: `admin/manage_users.jsp`

- `EditUserServlet` [GET, POST]
  - [GET] Param: `userId`; loads selected user; View: `admin/editUser.jsp`
  - [POST] Params: `userId`, `fullName`, `username`, `email`; updates user

- `DeleteUserServlet` [POST]
  - Param: `userId`; deletes from `users`
  - Redirects to `admin/delete_user_result.jsp` with session `message`|`error`

- `ManageAccountsServlet` [GET]
  - Requires role `Admin`
  - Lists all accounts; displays flash `message`/`error`
  - View: `admin/manage_accounts.jsp`

- `EditAccountServlet` [GET, POST]
  - [GET] Param: `accountNumber`; loads account; View: `admin/edit_account.jsp`
  - [POST] Params: `accountNumber`, `accountType`, `balance`; updates account

- `DeleteAccountServlet` [POST]
  - Param: `accountNumber`; deletes account; redirects back to `ManageAccountsServlet`

- `AdminTransactionServlet` [GET]
  - Optional `accountNumber`; if present, filters by that account
  - View: `admin/view_transactions.jsp`

- `ManageCardRequestsServlet` [GET]
  - Optional filter: `status` (Pending|Approved|Rejected)
  - View: `admin/manage_card_requests.jsp`

- `CardStatusActionServlet` [POST]
  - Params: `id` (application id), `action` (approve|reject)
  - Updates `card_applications.status`; redirect back to `ManageCardRequestsServlet`

- `AdminAnalysisServlet` [GET]
  - Loads stats via `AccountDAO`/`TransactionDAO`
  - View: `admin/analysis.jsp`

- `logout.jsp`
  - Invalidates session and redirects to `login.jsp`


## Data Models (POJOs)

- `User`
  - Fields: `userId`, `username`, `password`, `role`, `name`, `FullName`, `mobile`, `email`, `aadhar`, `accountType`, `initialDeposit`, `accounts: List<Account>`

- `Account`
  - Fields: `UserId`, `accountNumber`, `accountType`, `balance`

- `Transaction`
  - Fields: `id`, `fromAccount`, `toAccount`, `amount`, `type` (DEBIT|CREDIT), `timestamp`

- `CardApplication`
  - Fields: `id`, `userId`, `accountNumber`, `cardType`, `status`, `appliedAt`, `approvedAt`


## Persistence Layer (DAOs)
- `UserDAO`
  - `createUserAndAccount(User)` (prevents duplicate `aadhar`+`account_type`), `getUserByCredentials`, `getAllUsersWithAccounts`, `getUserById`, `updateUser`, `deleteUserById`
- `AccountDAO`
  - `getAccountByUserId`, `getAccountsByUserId`, `getAllAccounts`, `getAccountByNumber`, `updateAccount`, `deleteAccountByNumber`
  - Analytics: `getAccountTypeStats`, `getTotalBalanceByType`, `getMonthlyAccountStats`, `getTopUsersByBalance`
- `TransactionDAO`
  - `getAllTransactions`, `getFilteredTransactions`, `getTransactionsByAccount`, `getLastTransaction`, `getMonthlyTransactionStats`
- `CardApplicationDAO`
  - `applyForCard`, `getApplicationsByUser`, `getPendingApplications`/`getAllPendingApplications`, `getAllApplications`, `getApplicationsByStatus`, `updateStatus`
- `TransferDAO`
  - `getAccountByType`, `getAccountByNumber`, `transferFunds` (atomic debit/credit + inserts mirrored transactions)


## Business Services
- `AuthService`: `registerUserWithAccount`, `validateUser`
- `TransferService`: Validates account existence/balances and delegates to `TransferDAO`


## Database Setup
Update `com.tss.util.DBConnection` with your MySQL host, database, username, and password.

```java
// com.tss.util.DBConnection
private static final String URL = "jdbc:mysql://localhost:3306/bank_management";
private static final String USER = "root";
private static final String PASSWORD = "<your_password>"; // change this
```

Create the database and tables (example schema inferred from DAO usage):

```sql
CREATE DATABASE IF NOT EXISTS bank_management;
USE bank_management;

-- Users
CREATE TABLE IF NOT EXISTS users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role ENUM('Admin','Customer') NOT NULL,
  aadhar VARCHAR(12) NULL
);

-- Accounts
CREATE TABLE IF NOT EXISTS accounts (
  account_number VARCHAR(32) PRIMARY KEY,
  user_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  mobile VARCHAR(15) NOT NULL,
  email VARCHAR(100) NOT NULL,
  aadhar VARCHAR(12) NOT NULL,
  account_type ENUM('Savings','Current') NOT NULL,
  balance DECIMAL(15,2) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_accounts_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Transactions
CREATE TABLE IF NOT EXISTS transactions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  from_account VARCHAR(32) NOT NULL,
  to_account VARCHAR(32) NOT NULL,
  amount DECIMAL(15,2) NOT NULL,
  type ENUM('DEBIT','CREDIT') NOT NULL,
  timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_from_account (from_account),
  INDEX idx_to_account (to_account)
);

-- Card Applications
CREATE TABLE IF NOT EXISTS card_applications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  account_number VARCHAR(32) NOT NULL,
  card_type VARCHAR(50) NOT NULL,
  status ENUM('Pending','Approved','Rejected') NOT NULL DEFAULT 'Pending',
  applied_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  approved_at TIMESTAMP NULL,
  CONSTRAINT fk_card_app_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  CONSTRAINT fk_card_app_account FOREIGN KEY (account_number) REFERENCES accounts(account_number) ON DELETE CASCADE,
  UNIQUE KEY uniq_card_req (user_id, account_number, card_type, status)
);
```

Notes:
- The `uniq_card_req` uniqueness is to approximate the DAO check that prevents multiple Pending/Approved duplicates. You may adjust it to a partial uniqueness strategy (e.g., unique on (user_id, account_number, card_type) and enforce status in app logic).
- Add an initial admin user manually:

```sql
INSERT INTO users (username, password, role, aadhar) VALUES ('admin', 'admin', 'Admin', NULL);
```


## Running Locally
1. Prerequisites: JDK 8+, MySQL 5.7+/8.0+, Tomcat 8.5+/9/10, and MySQL Connector/J JAR.
2. Database: Create schema/tables above; update `DBConnection` credentials.
3. Dependencies: Place `mysql-connector-j-<version>.jar` into `src/main/webapp/WEB-INF/lib/` (or provide it via container lib).
4. Import into IDE: Import as an Eclipse Dynamic Web Project (project contains `.project`/`.classpath`).
5. Deploy: Run on Tomcat (Servlet 3.0+). Because Servlets use `@WebServlet`, no `web.xml` is required.
6. Access:
   - Login: `login.jsp`
   - Register: `register.jsp`
   - After login, use the left sidebar navigation within customer/admin pages.


## Security & Validation Notes
- Passwords are stored in plain text (per code). For production, hash passwords (e.g., BCrypt) and use HTTPS.
- No CSRF protection on POST endpoints; consider adding CSRF tokens.
- Input validation is minimal at server-side; add further validation and error handling as needed.
- Sessions are role-checked in Servlets but there is no centralized filter; consider adding a servlet filter for authz.


## Troubleshooting
- DB connection fails: verify `DBConnection` URL/USER/PASSWORD and that the MySQL driver JAR is present.
- 404 on Servlets: ensure Tomcat is using Servlet 3.0+ (annotations enabled) and app context path is correct.
- JDBC timezone errors: add `?serverTimezone=UTC` to JDBC URL if needed.
- Permission/role redirects: make sure the session has `user` and `role` set after login.


## License
No explicit license included. Add one if you plan to distribute.
