class ChargesController < ApplicationController

  def create
    # Creates a Stripe Customer object, for associating
    # with the charge
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )

    # Where the real magic happens - per Bloc explanation...
    charge = Stripe::Charge.create(
      customer: customer.id, # Note -- this is NOT the user_id in your app-stored
      amount: 1500,
      description: "Blocipedia Premium Account Access - #{current_user.email}",
      currency: 'usd'
    )

    current_user.premium!

    flash[:notice] = "Thank You for your patronage, #{current_user.email}. We appreciate the support!"
    redirect_to root_path

    # Stripe will send back CardErrors, with friendly messages
    # when something goes wrong.
    # This `rescue block` catches and displays those errors.

    rescue Stripe::CardError => e
      flash[:alert] = e.messages
      redirect_to new_charge_path
  end

  def new
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "Blocipedia Premium Account Access - #{current_user.email}",
      amount: 1500
    }
  end

  def to_standard
    current_user.standard!
    flash[:notice] = "We are sorry to see you cancel Premium Membership, #{current_user.email}."
    redirect_to root_path
  end

end
