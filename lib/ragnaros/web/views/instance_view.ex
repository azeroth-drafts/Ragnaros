defmodule Ragnaros.Web.InstanceView do
  use Ragnaros.Web, :view
  alias Ragnaros.Web.InstanceView

  def render("index.json", %{instances: instances}) do
    %{data: render_many(instances, InstanceView, "instance.json")}
  end

  def render("show.json", %{instance: instance}) do
    %{data: render_one(instance, InstanceView, "instance.json")}
  end

  def render("instance.json", %{instance: instance}) do
    %{id: instance.id,
      players: instance.players}
  end
end
