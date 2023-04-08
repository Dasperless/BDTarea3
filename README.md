# BDTarea3
<h5>Web site .NET</h5>
Website link: <strong><a href="appwebbd20230403132456.azurewebsites.net">Cuenta Ahorro - Banco Costa Rica</a></strong> : appwebbd20230403132456.azurewebsites.net
<h5>Data to enter sing up: </h5>
Email: <strong>Wartortle</strong>
Password: <strong>99436484</strong>

<h4>Project description:</h4>

Website about bank account. There is a user who can create a bank account
perform movements such as update beneficiaries, delete account, view account statement.
For this stage of the project, the following should be done:
The simulation script should calculate daily interest to the CO accounts.
Process CO Interest: Interest accrues, daily, until completion
of the CO, a table of COInterestMovements must be created, with credits every
days, the interest on the day that corresponds to the savings, is calculated prior to the CO deposit (the
savings of the month). Interest is calculated, credit is created and the amount is accumulated (interest
accumulated).
In the simulation, your script, when you process one day, before doing the
statements, you must add code to 'process CO', which has 2 parts:
process CO deposits and process CO redemption.
Process deposits in CO: if the day of the month the operation date coincides with the day the
day to save in CO, you must make a debit for withdrawal from the savings account and for
the same amount, you must make a deposit in the CO, the balance in the savings account will be
decreases and the balance in CO increases. The CO will have its own table of
movements (MovementCO) and its own table of TipoMovimientoCO, with 3 types of
Movements 1: Deposit for savings, 2: Deposit for interest redemption and, 3:
Redemption of the CO. If the balance in the savings account is going to be negative after the
deposit in CO, then it is not carried out.

Process CO Redemption: if the process date is equal to the final date of the CO. HE
redeem interest, that is, a debit is created for the full amount of interest on
the Interest movement table (so that the accrued interest remains
at zero) and a credit is generated for the same amount in the table of CO movements,
increased balance. Then the CO is redeemed, which consists of making a debit in
CO Movements for all savings (plus interest) so that your balance remains
at 0, and for that same amount it is deposited in a savings account, for the amount
of the total savings made in the CO (plus interest). The CO is deactivated.
The table of CO movements has the following structure (id int identity(1,1) primary key,
idMovementType int, date date, amount money, description varchar (100)
The table of movementsInteresCO has the following structure (id int identity(1,1)
primary key, idTipoMovimiento int, date date, amount money, description varchar (100))...
