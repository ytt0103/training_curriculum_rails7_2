class CalendarsController < ApplicationController

  # カレンダー表示画面
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    @todays_date = Date.today
    @week_days = []

    # 今週分の予定を一括取得
    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      date = @todays_date + x
      today_plans = []

      # 該当日の予定を抽出
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == date
      end

      # 曜日番号を取得（0〜6）
      wday_num = date.wday

      # 曜日を日本語に変換
      wday_str = wdays[wday_num]

      # 日付データを1日分ハッシュで格納
      days = {
        month: date.month,
        date: date.day,
        wday: wday_str,
        plans: today_plans
      }

      @week_days.push(days)
    end
  end
end