<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Purchase a Car</title>
    <link rel="stylesheet" href="car_installment_plans.css">
</head>

<body>
<!-- ======================================================================================-->

<%
'Defined variables ---------------------------------------------------------
Dim price, salary, amount, months, plan1, plan2, plan3, plan1_weeks, plan1_months, plan3_weeks, plan3_months
Dim adoCon, strSQL, button_pressed, email, rsobject, user_balance, update_balance, new_balance

' Get session email
email = Session("email")

'The form data 
price = Request.Form("price")
salary = Request.Form("salary")
amount = Request.Form("amount")
months = Request.Form("months")
button_pressed = Request.Form("payment_method")

'================================================================================
'Open Database connection 
'================================================================================

'Create an ADO(ActiveX Data Objects) connection object
Set adoCon = Server.CreateObject("ADODB.Connection")
'set an active connection to the Connectin object using a DSN-less connection  
adoCon.Open "Provider=Microsoft.ACE.OLEDB.16.0;Data Source=" & Server.MapPath("project.accdb") & ";Persist Security Info=False;"

'Create ADO recordset object  
Set rsobject = Server.CreateObject("ADODB.Recordset")

' get  user balance
strSQL = "SELECT balance FROM data WHERE email ='" & email & "' "
rsobject.Open strSQL, adoCon

'Check if reacord was found

If Not rsobject.EOF Then
'if we had a record  
    user_balance = rsobject("balance")
Else
    Response.Write("No record found for this email")
    Response.End
End If
rsobject.Close

'================================================================================
'Check if the payment button was clicked 
'================================================================================
' it means if the button_prssend was clicked then excute the following
If button_pressed <> "" Then  
    
    'update the balance value by deducting the first payment 

    If button_pressed = "plan1" Then
        new_balance = user_balance - amount 
    ElseIf button_pressed = "plan2" Then
        new_balance = user_balance - (price / months)
    ElseIf button_pressed = "plan3" Then
        new_balance = user_balance - (salary * 0.5)
    End If

    update_balance = "UPDATE data SET balance = '" & new_balance & "' WHERE email = '" & email & "' "
    adoCon.Execute update_balance

    ' Redirect to homepage
    Response.Redirect("homepage.html")
End If

'================================================================================
'Calculate plans  
'================================================================================

' Calculate plans if price and values are valid
If price > 0 And salary > 0 And amount > 0 And months > 0 Then
    plan1 = price / amount// return the months user spend in paying the price
    plan2 = price / months // return the money amount the player have to pay every month
    plan3 = price / (0.5 * salary)// return the months user spend in paying the price
Else
    plan1 = 1
    plan2 = 1
    plan3 = 1
End If

'Calculate how many months and weeks we might need for paying all the price ----------- 

plan1_months = Int(plan1)
plan1_weeks = Int((plan1 - plan1_months) * 4)

plan3_months = Int(plan3)
plan3_weeks = Int((plan3 - plan3_months) * 4)

' Close connection
adoCon.Close
%>

<!-- ======================================================================================-->

<header>
    <img class="header_logo" src="logo.png" alt="Bank Logo">
</header>

<div class="container">

    <!-- Print Plan 1 --------------------------------------------------------------------------->
    <div class="plan1">
        <h4>Plan 1</h4><br><br>
        <p>This plan fits the amount of money you prefer to pay monthly.</p><br><br>
        <p>If you paid <%= amount %> thousands every month, you will finish the car's installment in 
        <%= plan1_months %> months
        <% If plan1_weeks > 0 Then %> and 
            <%= plan1_weeks %> weeks
        <% End If %>
        </p>
        <form method="post" action="car_installment.asp">
            <input type="hidden" name="payment_method" value="plan1">
            <input type="hidden" name="price" value="<%= price %>">
            <input type="hidden" name="salary" value="<%= salary %>">
            <input type="hidden" name="amount" value="<%= amount %>">
            <input type="hidden" name="months" value="<%= months %>">
            <input type="submit" value="Start first payment">
        </form>
    </div>

    <!-- Print Plan 2 --------------------------------------------------------------------------->
    <div class="plan2">
        <h4>Plan 2</h4><br><br>
        <p>This plan fits the duration you prefer to finish the car's installment.</p><br><br>
        <p>You have to pay <%= plan2 %> thousands for <%= months %> months.</p>
        <form method="post" action="car_installment.asp">
            <input type="hidden" name="payment_method" value="plan2">
            <input type="hidden" name="price" value="<%= price %>">
            <input type="hidden" name="salary" value="<%= salary %>">
            <input type="hidden" name="amount" value="<%= amount %>">
            <input type="hidden" name="months" value="<%= months %>">
            <input type="submit" value="Start first payment">
        </form>
    </div>

    <!-- Print Plan 3 --------------------------------------------------------------------------->
    <div class="plan3">
        <h4>Plan 3</h4><br><br>
        <p>This plan is suggested by our bank team based on your monthly salary.</p>
        <p>If you paid <%= salary*0.5 %> thousands every month, you will finish the car's installment in 
        <%= plan3_months %> months
        <% If plan3_weeks > 0 Then %> and <%= plan3_weeks %> weeks<% End If %>
        </p>
        <form method="post" action="car_installment.asp">
            <input type="hidden" name="payment_method" value="plan3">
            <input type="hidden" name="price" value="<%= price %>">
            <input type="hidden" name="salary" value="<%= salary %>">
            <input type="hidden" name="amount" value="<%= amount %>">
            <input type="hidden" name="months" value="<%= months %>">
            <input type="submit" value="Start first payment">
        </form>
    </div>
</div>
<!-- ======================================================================================-->

</body>
</html>
