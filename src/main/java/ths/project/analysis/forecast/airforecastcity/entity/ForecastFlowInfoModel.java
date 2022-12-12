package ths.project.analysis.forecast.airforecastcity.entity;

public class ForecastFlowInfoModel {

    private String pkid;

    private String create_time;

    private String city_opinion;

    private String city_opinion_3day;

    private String country_opinion_3day;

    private String important_hints;

    private String inscribe;

    private String area_opinion;

    private String country_opinion;

    private String flow_state;

    private String save_user;

    private String[] result_time;

    private String[] aqi;

    private String[] aqi_level;

    private String[] prim_pollute;

    private String[] weather_trend;

    private String[] weather_level;

    /**
     * @return the pkid
     */
    public String getPkid() {
        return pkid;
    }

    /**
     * @param pkid the pkid to set
     */
    public void setPkid(String pkid) {
        this.pkid = pkid;
    }

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }

    public String getCity_opinion() {
        return city_opinion;
    }

    public void setCity_opinion(String city_opinion) {
        this.city_opinion = city_opinion;
    }

    public String getArea_opinion() {
        return area_opinion;
    }

    public void setArea_opinion(String area_opinion) {
        this.area_opinion = area_opinion;
    }

    /**
     * @return the country_opinion
     */
    public String getCountry_opinion() {
        return country_opinion;
    }

    /**
     * @param country_opinion the country_opinion to set
     */
    public void setCountry_opinion(String country_opinion) {
        this.country_opinion = country_opinion;
    }

    public String getFlow_state() {
        return flow_state;
    }

    public void setFlow_state(String flow_state) {
        this.flow_state = flow_state;
    }

    public String[] getResult_time() {
        return result_time;
    }

    public void setResult_time(String[] result_time) {
        this.result_time = result_time;
    }

    public String[] getAqi() {
        return aqi;
    }

    public void setAqi(String[] aqi) {
        this.aqi = aqi;
    }

    public String[] getAqi_level() {
        return aqi_level;
    }

    public void setAqi_level(String[] aqi_level) {
        this.aqi_level = aqi_level;
    }

    public String[] getPrim_pollute() {
        return prim_pollute;
    }

    public void setPrim_pollute(String[] prim_pollute) {
        this.prim_pollute = prim_pollute;
    }

    public String getSave_user() {
        return save_user;
    }

    public void setSave_user(String save_user) {
        this.save_user = save_user;
    }

    public String[] getWeather_trend() {
        return weather_trend;
    }

    public void setWeather_trend(String[] weather_trend) {
        this.weather_trend = weather_trend;
    }

    public String getCity_opinion_3day() {
        return city_opinion_3day;
    }

    public void setCity_opinion_3day(String city_opinion_3day) {
        this.city_opinion_3day = city_opinion_3day;
    }

    public String getCountry_opinion_3day() {
        return country_opinion_3day;
    }

    public void setCountry_opinion_3day(String country_opinion_3day) {
        this.country_opinion_3day = country_opinion_3day;
    }

    public String[] getWeather_level() {
        return weather_level;
    }

    public void setWeather_level(String[] weather_level) {
        this.weather_level = weather_level;
    }

    public String getImportant_hints() {
        return important_hints;
    }

    public void setImportant_hints(String important_hints) {
        this.important_hints = important_hints;
    }

    public String getInscribe() {
        return inscribe;
    }

    public void setInscribe(String inscribe) {
        this.inscribe = inscribe;
    }
}
