defmodule MsWeb.CustomerControllerTest do
  use MsWeb.ConnCase

  alias Ms.CustomerManagment
  alias Ms.CustomerManagment.Customer

  @create_attrs %{
    details: %{},
    name: "some name",
    phone: "some phone",
    pincode: "some pincode"
  }
  @update_attrs %{
    details: %{},
    name: "some updated name",
    phone: "some updated phone",
    pincode: "some updated pincode"
  }
  @invalid_attrs %{details: nil, name: nil, phone: nil, pincode: nil}

  def fixture(:customer) do
    {:ok, customer} = CustomerManagment.create_customer(@create_attrs)
    customer
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all customers", %{conn: conn} do
      conn = get(conn, Routes.customer_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create customer" do
    test "renders customer when data is valid", %{conn: conn} do
      conn = post(conn, Routes.customer_path(conn, :create), customer: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.customer_path(conn, :show, id))

      assert %{
               "id" => id,
               "details" => %{},
               "name" => "some name",
               "phone" => "some phone",
               "pincode" => "some pincode"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.customer_path(conn, :create), customer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update customer" do
    setup [:create_customer]

    test "renders customer when data is valid", %{conn: conn, customer: %Customer{id: id} = customer} do
      conn = put(conn, Routes.customer_path(conn, :update, customer), customer: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.customer_path(conn, :show, id))

      assert %{
               "id" => id,
               "details" => {},
               "name" => "some updated name",
               "phone" => "some updated phone",
               "pincode" => "some updated pincode"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, customer: customer} do
      conn = put(conn, Routes.customer_path(conn, :update, customer), customer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete customer" do
    setup [:create_customer]

    test "deletes chosen customer", %{conn: conn, customer: customer} do
      conn = delete(conn, Routes.customer_path(conn, :delete, customer))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.customer_path(conn, :show, customer))
      end
    end
  end

  defp create_customer(_) do
    customer = fixture(:customer)
    {:ok, customer: customer}
  end
end
