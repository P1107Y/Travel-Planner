## Travel Planner Application
Welcome to the Travel Planner application! This application is designed to assist users in planning their travel for various popular destinations. Below is an overview of the features and functionality provided by the Travel Planner. The prices shown in the application are during the trip (like stay, food and local travel) but travel to destination is not included.

### Screens
### 1. Home Screen
The Home screen serves as the entry point for users to input their travel details. Here, users can provide the following information:
Home Country: The user's home country.
Travel Budget: The budget allocated for the trip.
Currency Type: The currency in which the budget is specified.

The Home screen also displays a list of saved plans, persistently stored using sqflite. Each saved plan includes the following information:
Traveling From: The user's home country.
Traveling To: The destination of the travel plan.
Budget: The allocated budget for the trip.
Plan Possible: Indicates whether the travel plan is possible with the specified budget (Yes or No).

### 2. Destination Selection Screen
The Destination Selection screen presents users with 20 popular tourist destinations. Users can choose their desired destination from this list.

### 3. Plan Confirmation Screen
Upon selecting a destination, the Plan Confirmation screen provides detailed information on the feasibility of the travel plan based on the entered budget. It displays:

Converted Budget: Displays the user's budget converted to the destination's currency type using an API.
Plans Possible: Lists the plans possible for the entered budget, specifying the approximate budget required for different durations.
The currency conversion dynamically uses an API to ensure accurate and up-to-date exchange rates.

Users also have the option to save the plan for future reference.

Enjoy planning your travels with the Travel Planner application!
