Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration
Public Class WebForm15
    Inherits System.Web.UI.Page

    ' Connection string from Web.config
    Private connStr As String = ConfigurationManager.ConnectionStrings("ConnStr").ConnectionString

    ' Page load event
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Redirect to login if the user is not logged in
        If Session("UserID") Is Nothing Then
            Response.Redirect("~/Login.aspx")
            Return
        End If

        ' Load cart only on first page load (not on postbacks)
        If Not IsPostBack Then
            LoadCart()
        End If
    End Sub

    ' Loads the cart from session and binds data to the UI
    Private Sub LoadCart()
        Try
            Dim cart As List(Of CartItem) = GetSessionCart()

            If cart.Count = 0 Then
                ' If cart is empty, show empty panel
                pnlEmptyCart.Visible = True
                pnlCartItems.Visible = False
                lblCartCount.Text = "0"
            Else
                ' If cart has items, bind them to the repeater
                pnlEmptyCart.Visible = False
                pnlCartItems.Visible = True
                lblCartCount.Text = cart.Count.ToString()

                rptCartItems.DataSource = cart
                rptCartItems.DataBind()

                ' Calculate and display subtotal, addons, total, and discounts
                CalculateCartTotals(cart)
            End If

        Catch ex As Exception
            ShowMessage("Error loading cart: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Retrieves or initializes the session cart
    Private Function GetSessionCart() As List(Of CartItem)
        If Session("Cart") Is Nothing Then
            Session("Cart") = New List(Of CartItem)()
        End If
        Return CType(Session("Cart"), List(Of CartItem))
    End Function

    ' Calculates totals for the cart and updates the UI
    Private Sub CalculateCartTotals(cart As List(Of CartItem))
        Try
            Dim subtotal As Decimal = 0
            Dim addonsTotal As Decimal = 0
            Dim totalSavings As Decimal = 0

            For Each item As CartItem In cart
                ' Number of rental days
                Dim days As Integer = Math.Max(1, (item.EndDate - item.StartDate).Days + 1)

                ' Calculate base amount
                Dim baseAmount As Decimal = item.PricePerDay * days

                ' Apply discount
                Dim discountPercent As Decimal = GetDiscountPercentage(days)
                Dim discountAmount As Decimal = baseAmount * (discountPercent / 100)

                ' Update subtotal
                Dim itemSubtotal As Decimal = baseAmount - discountAmount
                subtotal += itemSubtotal

                ' Addon prices
                If item.Addons IsNot Nothing Then
                    For Each addon As CartAddon In item.Addons
                        addonsTotal += addon.PricePerDay * days
                    Next
                End If

                ' Track savings
                totalSavings += discountAmount
            Next

            ' Display subtotal, addons, total
            lblSubtotal.Text = subtotal.ToString("#,##0")
            lblAddonsTotal.Text = addonsTotal.ToString("#,##0")
            lblGrandTotal.Text = (subtotal + addonsTotal).ToString("#,##0")

            ' Show savings if any
            If totalSavings > 0 Then
                lblTotalSavings.Text = totalSavings.ToString("#,##0")
                pnlDiscountSummary.Visible = True
            Else
                pnlDiscountSummary.Visible = False
            End If

        Catch ex As Exception
            ShowMessage("Error calculating totals: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Returns applicable discount % based on number of days
    Private Function GetDiscountPercentage(days As Integer) As Decimal
        If days >= 61 AndAlso days <= 90 Then
            Return 20
        ElseIf days >= 31 AndAlso days <= 60 Then
            Return 15
        ElseIf days >= 11 AndAlso days <= 30 Then
            Return 12
        ElseIf days >= 4 AndAlso days <= 10 Then
            Return 8
        Else
            Return 0
        End If
    End Function

    ' Event handler for removing a single item from cart
    Protected Sub RemoveItem_Command(sender As Object, e As CommandEventArgs)
        Try
            Dim itemIndex As Integer = CInt(e.CommandArgument)
            Dim cart As List(Of CartItem) = GetSessionCart()

            If itemIndex >= 0 AndAlso itemIndex < cart.Count Then
                Dim removedItem As String = cart(itemIndex).VehicleName
                cart.RemoveAt(itemIndex)
                Session("Cart") = cart
                LoadCart()
                ShowMessage($"{removedItem} removed from cart successfully!", "alert-success")
            End If

        Catch ex As Exception
            ShowMessage("Error removing item: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Clears the entire cart
    Protected Sub btnClearCart_Click(sender As Object, e As EventArgs)
        Try
            Session("Cart") = New List(Of CartItem)()
            LoadCart()
            ShowMessage("Cart cleared successfully!", "alert-success")

        Catch ex As Exception
            ShowMessage("Error clearing cart: " & ex.Message, "alert-danger")
        End Try
    End Sub

    ' Calculates the number of rental days between two dates
    Protected Function CalculateDays(startDate As Object, endDate As Object) As Integer
        If startDate Is Nothing OrElse endDate Is Nothing Then Return 0

        Try
            Dim start As DateTime = CDate(startDate)
            Dim endD As DateTime = CDate(endDate)
            Return Math.Max(1, (endD - start).Days + 1)
        Catch
            Return 0
        End Try
    End Function

    ' Fetches the image path for a vehicle by VehicleID
    Protected Function GetVehicleImage(vehicleID As Object) As String
        If vehicleID IsNot Nothing AndAlso Not IsDBNull(vehicleID) Then
            Try
                Using con As New SqlConnection(connStr)
                    con.Open()
                    Dim cmd As New SqlCommand("SELECT TOP 1 ImagePath FROM VehicleImages WHERE VehicleID = @VehicleID AND ImageType = 'Primary' AND IsActive = 1 ORDER BY DisplayOrder", con)
                    cmd.Parameters.AddWithValue("@VehicleID", vehicleID)

                    Dim imagePath As Object = cmd.ExecuteScalar()
                    If imagePath IsNot Nothing AndAlso Not IsDBNull(imagePath) AndAlso Not String.IsNullOrEmpty(imagePath.ToString()) Then
                        Dim path As String = imagePath.ToString()
                        If path.StartsWith("~/") Then
                            path = path.Substring(2)
                        End If
                        Return path
                    End If
                End Using
            Catch
                ' Ignore errors silently
            End Try
        End If
        ' Return default image if not found
        Return "images/no-vehicle-image.jpg"
    End Function

    ' Checks if the cart item has any add-ons
    Protected Function HasAddons(dataItem As Object) As Boolean
        Try
            Dim cartItem As CartItem = CType(dataItem, CartItem)
            Return cartItem.Addons IsNot Nothing AndAlso cartItem.Addons.Count > 0
        Catch
            Return False
        End Try
    End Function

    ' Builds a readable string of add-ons with their daily prices
    Protected Function GetAddonsList(dataItem As Object) As String
        Try
            Dim cartItem As CartItem = CType(dataItem, CartItem)
            If cartItem.Addons Is Nothing OrElse cartItem.Addons.Count = 0 Then
                Return "No add-ons selected"
            End If

            Dim addonNames As New List(Of String)()

            Using con As New SqlConnection(connStr)
                con.Open()

                For Each addon As CartAddon In cartItem.Addons
                    Dim query As String = "SELECT AddonName FROM Addons WHERE AddonID = @AddonID"
                    Dim cmd As New SqlCommand(query, con)
                    cmd.Parameters.AddWithValue("@AddonID", addon.AddonID)

                    Dim addonName As Object = cmd.ExecuteScalar()
                    If addonName IsNot Nothing Then
                        addonNames.Add($"{addonName} (+Rs {addon.PricePerDay:#,##0}/day)")
                    End If
                Next
            End Using

            Return String.Join(", ", addonNames)

        Catch ex As Exception
            Return "Error loading add-ons"
        End Try
    End Function

    ' Calculates the total for an item including discount and add-ons
    Protected Function GetItemTotalWithAddons(dataItem As Object) As String
        Try
            Dim cartItem As CartItem = CType(dataItem, CartItem)
            Dim days As Integer = Math.Max(1, (cartItem.EndDate - cartItem.StartDate).Days + 1)

            ' Calculate base with discount
            Dim baseAmount As Decimal = cartItem.PricePerDay * days
            Dim discountPercent As Decimal = GetDiscountPercentage(days)
            Dim discountedAmount As Decimal = baseAmount * ((100 - discountPercent) / 100)

            ' Addons
            Dim addonsTotal As Decimal = 0
            If cartItem.Addons IsNot Nothing Then
                For Each addon As CartAddon In cartItem.Addons
                    addonsTotal += addon.PricePerDay * days
                Next
            End If

            Dim total As Decimal = discountedAmount + addonsTotal
            Return total.ToString("#,##0")
        Catch
            Return "0"
        End Try
    End Function

    ' Returns a string with discount info badge (if applicable)
    Protected Function GetDiscountInfo(dataItem As Object) As String
        Try
            Dim cartItem As CartItem = CType(dataItem, CartItem)
            Dim days As Integer = Math.Max(1, (cartItem.EndDate - cartItem.StartDate).Days + 1)
            Dim discountPercent As Decimal = GetDiscountPercentage(days)

            If discountPercent > 0 Then
                Return $"<br><span class='discount-badge'>{discountPercent}% discount applied</span>"
            Else
                Return ""
            End If
        Catch
            Return ""
        End Try
    End Function

    ' Shows success/error message in Bootstrap alert
    Private Sub ShowMessage(message As String, cssClass As String)
        lblMessage.Text = message
        pnlMessage.CssClass = "position-fixed alert " & cssClass & " alert-dismissible fade show"
        pnlMessage.Visible = True

        ' Auto-hide message after 5 seconds using JavaScript
        ClientScript.RegisterStartupScript(Me.GetType(), "hideMessage",
            "setTimeout(function(){ " &
            "var msgPanel = document.getElementById('" & pnlMessage.ClientID & "'); " &
            "if(msgPanel) msgPanel.style.display = 'none'; " &
            "}, 5000);", True)
    End Sub

End Class