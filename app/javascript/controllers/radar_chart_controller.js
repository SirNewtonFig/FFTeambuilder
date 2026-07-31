import { Controller } from "@hotwired/stimulus"
import ApexCharts from 'apexcharts'

export default class RadarChartController extends Controller {
  static targets = ['chart']

  static values = {
    chartData: Object
  }

  connect() {
    const chart = new ApexCharts(this.chartTarget, this.chartDataValue)

    chart.render()
  }
}
