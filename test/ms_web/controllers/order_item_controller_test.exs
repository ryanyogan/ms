defmodule MsWeb.OrderItemControllerTest do
  use MsWeb.ConnCase

  alias Ms.OrderManagement
  alias Ms.OrderManagement.OrderItem

  @create_attrs %{
    amount: 42,
    unitPrice: 120.5
  }
  @update_attrs %{
    amount: 43,
    unitPrice: 456.7
  }
  @invalid_attrs %{amount: nil, unitPrice: nil}

  def fixture(:order_item) do
    {:ok, order_item} = OrderManagement.create_order_item(@create_attrs)
    order_item
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all order_items", %{conn: conn} do
      conn = get(conn, Routes.order_item_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create order_item" do
    test "renders order_item when data is valid", %{conn: conn} do
      conn = post(conn, Routes.order_item_path(conn, :create), order_item: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.order_item_path(conn, :show, id))

      assert %{
               "id" => id,
               "amount" => 42,
               "unitPrice" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.order_item_path(conn, :create), order_item: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update order_item" do
    setup [:create_order_item]

    test "renders order_item when data is valid", %{conn: conn, order_item: %OrderItem{id: id} = order_item} do
      conn = put(conn, Routes.order_item_path(conn, :update, order_item), order_item: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.order_item_path(conn, :show, id))

      assert %{
               "id" => id,
               "amount" => 43,
               "unitPrice" => 456.7
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, order_item: order_item} do
      conn = put(conn, Routes.order_item_path(conn, :update, order_item), order_item: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete order_item" do
    setup [:create_order_item]

    test "deletes chosen order_item", %{conn: conn, order_item: order_item} do
      conn = delete(conn, Routes.order_item_path(conn, :delete, order_item))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.order_item_path(conn, :show, order_item))
      end
    end
  end

  defp create_order_item(_) do
    order_item = fixture(:order_item)
    {:ok, order_item: order_item}
  end
end
