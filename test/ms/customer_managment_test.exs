defmodule Ms.CustomerManagmentTest do
  use Ms.DataCase

  alias Ms.CustomerManagment

  describe "customers" do
    alias Ms.CustomerManagment.Customer

    @valid_attrs %{details: %{}, name: "some name", phone: "some phone", pincode: "some pincode"}
    @update_attrs %{details: %{}, name: "some updated name", phone: "some updated phone", pincode: "some updated pincode"}
    @invalid_attrs %{details: nil, name: nil, phone: nil, pincode: nil}

    def customer_fixture(attrs \\ %{}) do
      {:ok, customer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CustomerManagment.create_customer()

      customer
    end

    test "list_customers/0 returns all customers" do
      customer = customer_fixture()
      assert CustomerManagment.list_customers() == [customer]
    end

    test "get_customer!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert CustomerManagment.get_customer!(customer.id) == customer
    end

    test "create_customer/1 with valid data creates a customer" do
      assert {:ok, %Customer{} = customer} = CustomerManagment.create_customer(@valid_attrs)
      assert customer.details == %{}
      assert customer.name == "some name"
      assert customer.phone == "some phone"
      assert customer.pincode == "some pincode"
    end

    test "create_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CustomerManagment.create_customer(@invalid_attrs)
    end

    test "update_customer/2 with valid data updates the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{} = customer} = CustomerManagment.update_customer(customer, @update_attrs)
      assert customer.details == %{}
      assert customer.name == "some updated name"
      assert customer.phone == "some updated phone"
      assert customer.pincode == "some updated pincode"
    end

    test "update_customer/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      assert {:error, %Ecto.Changeset{}} = CustomerManagment.update_customer(customer, @invalid_attrs)
      assert customer == CustomerManagment.get_customer!(customer.id)
    end

    test "delete_customer/1 deletes the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = CustomerManagment.delete_customer(customer)
      assert_raise Ecto.NoResultsError, fn -> CustomerManagment.get_customer!(customer.id) end
    end

    test "change_customer/1 returns a customer changeset" do
      customer = customer_fixture()
      assert %Ecto.Changeset{} = CustomerManagment.change_customer(customer)
    end
  end
end
