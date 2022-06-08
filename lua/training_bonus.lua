--<<
function wesnoth.effects.training_bonus(u, cfg)
	local amount = cfg.amount or 1
    if not type(amount) == "number" then
        helper.wml_error("amount shoud be a number")
    end
    local current_bonus = u.variables["wc2.invest_mod.training_bonus"] or 0
    new_cfg = helper.parsed(helper.get_child(cfg, "wc2_random_training"))
    u.variables["wc2.invest_mod.training_bonus.amount"] = amount + current_bonus
    u.variables["wc2.invest_mod.training_bonus.among"] = new_cfg.among
end


function wc2_invest_process_training_advances(u)
    local counter=0
    local advs = u.modification.advancement
    for i=1,#advs-1,1
    do
        if advs[i].id=="invest_advancement" then
            counter = counter+1
        end
    end
    if u.variables["wc2.invest_mod.training_bonus_applied"] and u.variables["wc2.invest_mod.training_bonus_applied"] < counter then
        new_cfg = {
            side = u.side,
            among = "2,3,4,5,6"
        }
        wesnoth.wml_actions.wc2_give_random_training(new_cfg)
        if u.variables["wc2.invest_mod.training_bonus_applied"] == nil then
            u.variables["wc2.invest_mod.training_bonus_applied"] = 1
        else
            u.variables["wc2.invest_mod.training_bonus_applied"] = u.variables["wc2.invest_mod.training_bonus_applied"] + 1
        end
    end
end

function wesnoth.wml_actions.wc2_process_training_advancements(cfg)
    local leaders = wesnoth.units.find_on_map{ canrecruit = true }
    for i=1,#leaders-1,1
    do
        u=leaders[i]
        wc2_invest_process_training_advances(u)
    end
end
-->>