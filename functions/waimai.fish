function waimai
        # read --prompt "echo '人数: ' " -l name
        echo "#------------- 死肥宅天天吃外卖 -------------#"
        read --prompt "echo '套餐价格: ' " -l prices
        read --prompt "echo '餐具费: ' " -l tools
        read --prompt "echo '配送费: ' " -l delivery_fee
        read --prompt "echo '总共优惠: ' " -l preferences

        set -l prices (string split ' ' $prices)
        set -l members (count $prices)
        set -l tog_fee (math $tools + $delivery_fee)
        set -l average_fee (math -s3 $tog_fee / $members)

        # 总花费 不带优惠
        set -g total_coast (echo $tog_fee) 
        for p in $prices
                set -g total_coast (math $p + $total_coast)
        end
        
        set -l final_total_price (math $total_coast - $preferences)
        
        set -g index 1
        for p in $prices
                set -l n (math (math -s3 (math $average_fee + $p) / $total_coast) \* $final_total_price)
                echo "第$index人应付: ￥$n"
                set -g index (math $index + 1)
        end
end
