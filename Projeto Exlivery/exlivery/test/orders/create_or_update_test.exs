defmodule Exlivery.Orders.CreateOrUpdateTest do
  use ExUnit.Case
  import Exlivery.Factory

  alias Exlivery.Users.Agent, as: UserAgent
  alias Exlivery.Orders.CreateOrUpdate

  describe "call/1" do

    setup do


    cpf= "78945612300"
    user = build(:user, cpf: cpf)

Exlivery.start_agents()
    UserAgent.save(user)

    item1 = %{
      category: :pizza,
      description: "Pizza de Peperoni",
      quantity: 1,
      unity_price: "35.50"
    }

    item2 = %{
      category: :pizza,
      description: "Pizza de Azeitone",
      quantity: 2,
      unity_price: "25.50"
    }
    {:ok, user_cpf: cpf, item1: item1, item2: item2}

  end

   test "When all params are valid, saves the order" , %{user_cpf: cpf, item1: item1, item2: item2} do
    params = %{user_cpf: cpf, items: [item1, item2]}

    response = CreateOrUpdate.call(params)

    assert {:ok, _uuid} = response
  end

  test "when there is no user with given cpf, returns an error", %{item1: item1, item2: item2} do
       params = %{user_cpf: "00000000", items: [item1, item2]}

    response = CreateOrUpdate.call(params)
expected_response = {:error, "User not found"}
    assert response == expected_response
  end

    test "when there are invalid items, returns an error", %{
      user_cpf: cpf,
       item1: item1,
        item2: item2} do
    params = %{user_cpf: cpf, items: [%{item1 | quantity: 0}, item2]}

    response = CreateOrUpdate.call(params)
    expected_response = {:error, "Ivalid items"}
    assert response == expected_response
  end

      test "when no items, returns an error", %{
      user_cpf: cpf} do
    params = %{user_cpf: cpf, items: []}

    response = CreateOrUpdate.call(params)
    expected_response = {:error, "Invalid Parameters"}
    assert response == expected_response
  end



  end
end
