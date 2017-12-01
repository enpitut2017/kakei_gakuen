function users_init() {
  today = getDate();

  $('#date').val(today);
  $('#date').datepicker({
    format: "yyyy-mm-dd"
  });
}

function parse_home(text) {
  if(text){
    text = text.replace(/\s|　|\.|\,|円/g, '');
    text = text.replace(/万/g, '0000');
    text = text.replace(/千/g, '000');
    item = text.replace(/\d+/g, ' ');
    cost = text.replace(/\D+/g, ' ');
    items = item.split(' ');
    costs = cost.split(' ');
    items = $.grep(items, function(e){return e !== "";});
    costs = $.grep(costs, function(e){return e !== "";});
    for (i = 0; i < costs.length; i++){
        if (costs[i].length >= 10) {
            costs[i] = "国家予算超えちゃうよ！";
        }
    }
    $('#item-home').val(items[0]);
    $('#cost-home').val(costs[0]);
  }
}
