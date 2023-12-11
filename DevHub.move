module DevHub {
    import 0x1::NFT;

    // ... (existing code)

    public resource struct DevCard {
        id: u64;
        name: string;
        owner: address;
        description: vector<u8>;
        open_to_work: bool;
        portfolio: vector<u8>;
    }

    // ... (existing code)

    public event PortfolioUpdated {
        name: String,
        owner: address,
        new_portfolio: String,
    }

    public entry fun update_portfolio(devhub: &mut DevHub, new_portfolio: vector<u8>, id: u64, ctx: &mut TxContext) {
        let user_card = object_table::borrow_mut(&mut devhub.cards, id);
        assert!(tx_context::sender(ctx) == user_card.owner, NOT_THE_OWNER);

        let old_portfolio = option::swap_or_fill(&mut user_card.portfolio, string::utf8(new_portfolio));

        event::emit(
            PortfolioUpdated {
                name: user_card.name,
                owner: user_card.owner,
                new_portfolio: string::utf8(new_portfolio),
            }
        );

        _ = old_portfolio;
    }

    // ... (existing code)
};